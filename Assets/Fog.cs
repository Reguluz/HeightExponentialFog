using System.Collections;
using System.Collections.Generic;
using UnityEngine;
[ExecuteInEditMode]
public class Fog : MonoBehaviour
{
    public Color fogColor;
    public float fogSkyboxStart;
    public float fogSkyboxGradientLength;
    public float fogHeight;
    [Range(0,1)]public float fogDensity;
    [Min(0f)]public float fogFalloff;
    [Min(0f)]public float fogStartDis;
    public float fogInscatteringExp;
    private static readonly int FogColor = Shader.PropertyToID("_FogColor");
    private static readonly int FogGlobalDensity = Shader.PropertyToID("_FogGlobalDensity");
    private static readonly int FogFallOff = Shader.PropertyToID("_FogFallOff");
    private static readonly int FogHeight = Shader.PropertyToID("_FogHeight");
    private static readonly int FogStartDis = Shader.PropertyToID("_FogStartDis");
    private static readonly int FogInscatteringExp = Shader.PropertyToID("_FogInscatteringExp");


    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void OnValidate()
    {
        if (fogSkyboxGradientLength < 0.01f)
        {
            fogSkyboxGradientLength = 0.01f;
        }
        Shader.SetGlobalColor(FogColor, fogColor);
        Shader.SetGlobalFloat(FogGlobalDensity, fogDensity * 0.01f);
        Shader.SetGlobalFloat(FogFallOff, fogFalloff);
        Shader.SetGlobalFloat(FogHeight, fogHeight);
        Shader.SetGlobalFloat(FogStartDis, fogStartDis);
        Shader.SetGlobalFloat(FogInscatteringExp, fogInscatteringExp);
    }
}
