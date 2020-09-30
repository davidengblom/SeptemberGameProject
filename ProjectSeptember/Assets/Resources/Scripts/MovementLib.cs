using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MovementLib : MonoBehaviour
{
    //Layers
    private LayerMask ground;
    private LayerMask stairs;
    private LayerMask moveable;
    private LayerMask walls;

    private void Awake()
    {
        ground = LayerMask.GetMask("Ground");
        stairs = LayerMask.GetMask("Stairs");
        moveable = LayerMask.GetMask("Moveable");
        walls = LayerMask.GetMask("Walls");

    }
}



