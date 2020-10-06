using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class GlobalFog : MonoBehaviour
{
public float Distance=6f;
public float Falloff=6f;
    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    
    void Update()
    {
     Shader.SetGlobalFloat("Distance", Distance);
     Shader.SetGlobalFloat("Falloff", Falloff);
    }
}
