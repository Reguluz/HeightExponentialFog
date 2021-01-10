#ifndef CUSTOM_FOG_INCLUDE
#define CUSTOM_FOG_INCLUDE

#include "UnityLightingCommon.cginc"
float3 _FogColor;

//Object
float _FogGlobalDensity;
float _FogFallOff;
float _FogHeight;
float _FogStartDis;
float _FogInscatteringExp;

sampler2D _CameraDepthTexture;

float GetDepth(float4 uv)
{
   return LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2D(_CameraDepthTexture, uv.xy)));
}

#define ExponentialHeightFog(col, posWorld) \
    half heightFallOff = _FogFallOff * 0.001;\
    half falloff = heightFallOff * (posWorld.y - _WorldSpaceCameraPos.y);\
    half fogDensity = _FogGlobalDensity * exp2(-heightFallOff * (_WorldSpaceCameraPos.y - _FogHeight));\
    half fogFactor = (1 - exp2(-falloff))/falloff;\
    half3 viewDir = _WorldSpaceCameraPos - posWorld;\
    half rayLength = length(viewDir);\
    half fog = fogFactor * fogDensity * max(rayLength - _FogStartDis, 0);\
    half inscatterFog = pow(saturate(dot(normalize(viewDir), _WorldSpaceLightPos0)), _FogInscatteringExp);\
    inscatterFog *= 1-saturate(exp2(falloff));\
    inscatterFog *= max(rayLength - _FogStartDis, 0);\
    half3 finalFogColor = lerp(_FogColor, _LightColor0, saturate(inscatterFog));\
    col = lerp(col, finalFogColor, saturate(fog));
    

#endif
