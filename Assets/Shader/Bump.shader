Shader "Unlit/Bump"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        [NoScaleOffset] _BumpMap ("Normalmap", 2D) = "bump" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma shader_feature _FOG_ON

            #include "UnityCG.cginc"
            #include "Header.cginc"
            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float3 tangent : TANGENT;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
                // UNITY_FOG_COORDS(1)
                float3 posWorld : TEXCOORD1;
                float3 normalWS : TEXCOORD2;
                float3 tangentWS : TEXCOORD3;
                float3 bitangentWS : TEXCOORD4;
                float4 screenPos : TEXCOORD5;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            sampler2D _BumpMap;
            

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.bitangentWS = UnityObjectToWorldDir(cross(v.normal, v.tangent));
                o.tangentWS= UnityObjectToWorldDir(v.tangent);
                o.normalWS = UnityObjectToWorldDir(v.normal);
                o.screenPos = ComputeScreenPos(o.vertex);
                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                // sample the texture
                half3 normalTS = UnpackNormal(tex2D(_BumpMap, i.uv));
                half3x3 TBN = half3x3(i.tangentWS, i.bitangentWS, i.normalWS);
                half3 normalWS = mul(normalTS, TBN);
                
                half3 L = UnityWorldSpaceLightDir(i.posWorld);
                half NdL = dot(normalWS, L) * 0.5 + 0.5;
                
                
                half4 col = tex2D(_MainTex, i.uv);
            #ifdef _FOG_ON
                col.xyz = ExponentialHeightFog(col.xyz, i.posWorld);
            #endif
                return half4(col.xyz,1);
            }
            ENDCG
        }
    }
}
