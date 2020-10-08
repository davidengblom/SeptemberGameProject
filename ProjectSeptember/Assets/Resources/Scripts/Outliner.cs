using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Outliner : MonoBehaviour
{
    private MoveableMovement movement;

    public Material defaultMat;
    public Material outlineMat;

    private Renderer render;

    private void Start()
    {
        movement = GetComponent<MoveableMovement>();
        render = GetComponent<Renderer>();
    }

    public void CreateOutline() => render.material = outlineMat;

    public void DeleteOutline() => render.material = defaultMat;
}
