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

half3 ExponentialHeightFog(half3 col, half3 posWorld)
{
    half heightFallOff = _FogFallOff * 0.01;
    half falloff = heightFallOff * ( posWorld.y -  _WorldSpaceCameraPos.y- _FogHeight);
    half fogDensity = _FogGlobalDensity * exp2(-falloff);
    half fogFactor = (1 - exp2(-falloff))/falloff;
    half3 viewDir = _WorldSpaceCameraPos - posWorld;
    half rayLength = length(viewDir);
    half fog = fogFactor * fogDensity * max(rayLength - _FogStartDis, 0);
    
    half inscatterFog = pow(saturate(dot(-normalize(viewDir), WorldSpaceLightDir(half4(posWorld,1)))), _FogInscatteringExp);
    // inscatterFog *= 1-saturate(exp2(falloff));
    // inscatterFog *= max(rayLength - _FogStartDis, 0);
    // return inscatterFog;
    half3 finalFogColor = lerp(_FogColor, _LightColor0, saturate(inscatterFog));
    return lerp(col, finalFogColor, saturate(fog));
}
#define EXPONENTIALHEIGHTFOG(col, posWorld) \
    half heightFallOff = _FogFallOff * 0.001;\
    half falloff = heightFallOff * (posWorld.y - _WorldSpaceCameraPos.y);\
    half fogDensity = _FogGlobalDensity * exp2(-heightFallOff * (_WorldSpaceCameraPos.y - _FogHeight));\
    half fogFactor = (1 - exp2(-falloff))/falloff;\
    half3 viewDir = _WorldSpaceCameraPos - posWorld;\
    half rayLength = length(viewDir);\
    half fog = fogFactor * fogDensity * max(rayLength - _FogStartDis, 0);\
    half inscatterFog = pow(saturate(dot(normalize(viewDir), _WorldSpaceLightPos0 - posWorld)), _FogInscatteringExp);\
    inscatterFog *= 1-saturate(exp2(falloff));\
    inscatterFog *= max(rayLength - _FogStartDis, 0);\
    half3 finalFogColor = lerp(_FogColor, _LightColor0, saturate(inscatterFog));\
    col = lerp(col, finalFogColor, saturate(fog));
    

#endif
