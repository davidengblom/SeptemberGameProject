using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterMovement : MonoBehaviour
{
    public float moveSpeed = 5f;

    public Transform movePoint;

    public LayerMask ground;

    private void Start()
    {
        movePoint.parent = null;
    }

    private void FixedUpdate()
    {
        transform.position = Vector3.MoveTowards(transform.position, movePoint.position, moveSpeed * Time.deltaTime);
    }
    private void Update()
    {

        if(Vector3.Distance(transform.position, movePoint.position) <= .05f)
        {
            if(Physics.OverlapSphere(movePoint.position + new Vector3(Input.GetAxisRaw("Horizontal"), 0f, 0f), .2f, ground).Length > 0) //Fix collision detection
            {
                if (Mathf.Abs(Input.GetAxisRaw("Horizontal")) == 1)
                {
                    movePoint.position += new Vector3(Input.GetAxisRaw("Horizontal"), 0f, 0f);
                }

                if (Mathf.Abs(Input.GetAxisRaw("Vertical")) == 1)
                {
                    movePoint.position += new Vector3(0f, 0f, Input.GetAxisRaw("Vertical"));
                }
            }

        }
    }

}
