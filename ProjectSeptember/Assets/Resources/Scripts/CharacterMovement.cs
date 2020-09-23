using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterMovement : MonoBehaviour
{
    public float moveSpeed = 5f;

    public Transform movePoint;

    public LayerMask ground;

    public bool canWalkX;
    public bool canWalkZ;

    private void Start()
    {
        movePoint.parent = null;
        ground = LayerMask.GetMask("Ground");
    }

    private void FixedUpdate()
    {
        transform.position = Vector3.MoveTowards(transform.position, movePoint.position, moveSpeed * Time.deltaTime);
    }
    private void Update()
    {
        canWalkX = Physics.CheckSphere(movePoint.position + new Vector3(Input.GetAxisRaw("Horizontal"), -0.75f, 0f), .2f, ground);
        canWalkZ = Physics.CheckSphere(movePoint.position + new Vector3(0f, -0.75f, Input.GetAxisRaw("Vertical")), .2f, ground);

        if (Vector3.Distance(transform.position, movePoint.position) <= .05f)
        {
            if (Mathf.Abs(Input.GetAxisRaw("Horizontal")) == 1)
            {
                if (canWalkX)
                {
                    movePoint.position += new Vector3(Input.GetAxisRaw("Horizontal"), 0f, 0f);
                }

            }
            else if (Mathf.Abs(Input.GetAxisRaw("Vertical")) == 1)
            {
                if (canWalkZ)
                {
                    movePoint.position += new Vector3(0f, 0f, Input.GetAxisRaw("Vertical"));
                }
            }


        }
    }

}
