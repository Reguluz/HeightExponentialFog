#ifndef CUSTOM_FOG_INCLUDE
#define CUSTOM_FOG_INCLUDE

#include "UnityLightingCommon.cginc"
float3 _FogColor;

float _FogGlobalDensity;
float _FogFallOff;
float _FogHeight;
float _FogStartDis;
float _FogInscatteringExp;
float _FogGradientDis;

half3 ExponentialHeightFog(half3 col, half3 posWorld)
{
    half heightFallOff = _FogFallOff * 0.01;
    half falloff = heightFallOff * ( posWorld.y -  _WorldSpaceCameraPos.y- _FogHeight);
    half fogDensity = _FogGlobalDensity * exp2(-falloff);
    half fogFactor = (1 - exp2(-falloff))/falloff;
    half3 viewDir = _WorldSpaceCameraPos - posWorld;
    half rayLength = length(viewDir);
    half distanceFactor = max((rayLength - _FogStartDis)/ _FogGradientDis, 0);
    half fog = fogFactor * fogDensity * distanceFactor;
    half inscatterFactor = pow(saturate(dot(-normalize(viewDir), WorldSpaceLightDir(half4(posWorld,1)))), _FogInscatteringExp);
    inscatterFactor *= 1-saturate(exp2(falloff));
    inscatterFactor *= distanceFactor;
    half3 finalFogColor = lerp(_FogColor, _LightColor0, saturate(inscatterFactor));
    return lerp(col, finalFogColor, saturate(fog));
}

#endif
