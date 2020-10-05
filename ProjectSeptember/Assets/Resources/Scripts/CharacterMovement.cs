using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CharacterMovement : MonoBehaviour
{
    [Header("Components")]
    [Tooltip("The indicator that the player is constantly moving towards.")]
    public Transform movePoint;

    [Header("Variables")]
    [Tooltip("The speed at which the player moves.")]
    public float moveSpeed = 5f;

    [Header("Keybinds")]
    [Tooltip("Key to be pressed to interact with objects.")]
    [SerializeField]
    private KeyCode interactKey = KeyCode.E;

    private LayerMask ground;
    private LayerMask stairs;

    private bool canWalkX; //Checks if there is ground to the left/right of the player
    private bool canWalkZ; //Check if there is ground in front of/behind the player

    private Collider[] interactableRight; //Check if there is an interactable in range of the player (Right, Left, Front, Back)
    private Collider[] interactableLeft;
    private Collider[] interactableUp;
    private Collider[] interactableDown;

    private bool canWalkStairX; //Checks if there are stairs to the left/right of the player
    private bool canWalkStairZ; //Checks if there are stairs in front of/behind the player

    private void Start()
    {
        movePoint.parent = null;
        ground = LayerMask.GetMask("Ground");
        stairs = LayerMask.GetMask("Stairs");
    }

    private void FixedUpdate()
    {
        if (transform.position != movePoint.position)
        {
            transform.position = Vector3.MoveTowards(transform.position, movePoint.position, moveSpeed * Time.deltaTime);
        }
    }

    private void OnTriggerEnter(Collider obj)
    {
        if (obj.gameObject.CompareTag("Box"))
        {
            transform.position += new Vector3(0f, 0.5f, 0f);
            movePoint.position += new Vector3(0f, 0.5f, 0f);
        }
    }

    private void OnTriggerExit(Collider obj)
    {
        if(obj.gameObject.CompareTag("Box"))
        {
            transform.position += new Vector3(0f, -0.5f, 0f);
            movePoint.position += new Vector3(0f, -0.5f, 0f);
        }
    }

    private void Update()
    {
        canWalkX = Physics.CheckSphere(movePoint.position + new Vector3(Input.GetAxisRaw("Horizontal"), -0.75f, 0f), 0.2f, ground);
        canWalkZ = Physics.CheckSphere(movePoint.position + new Vector3(0f, -0.75f, Input.GetAxisRaw("Vertical")), 0.2f, ground);

        canWalkStairX = Physics.CheckSphere(movePoint.position + new Vector3(Input.GetAxisRaw("Horizontal"), -0.75f, 0f), 0.2f, stairs);
        canWalkStairZ = Physics.CheckSphere(movePoint.position + new Vector3(0f, -0.75f, Input.GetAxisRaw("Vertical")), 0.2f, stairs);

        Collider[] stairsX = Physics.OverlapSphere(movePoint.position + new Vector3(Input.GetAxisRaw("Horizontal"), -0.75f, 0f), 0.2f, stairs);
        Collider[] stairsZ = Physics.OverlapSphere(movePoint.position + new Vector3(0f, -0.75f, Input.GetAxisRaw("Vertical")), 0.2f, stairs);

        interactableRight = Physics.OverlapSphere(transform.position + new Vector3(1f, 0f, 0f), 0.2f, stairs); //Change the stair layer to include all interactables
        interactableLeft = Physics.OverlapSphere(transform.position + new Vector3(-1f, 0f, 0f), 0.2f, stairs);
        interactableUp = Physics.OverlapSphere(transform.position + new Vector3(0f, 0f, 1f), 0.2f, stairs);
        interactableDown = Physics.OverlapSphere(transform.position + new Vector3(0f, 0f, -1f), 0.2f, stairs);

        if(interactableRight.Length > 0)
        {
            if(Input.GetKeyDown(interactKey))
            {
                interactableRight[0].GetComponent<MoveableMovement>().isControlled = true;
            }
        }
        else if(interactableLeft.Length > 0)
        {
            if(Input.GetKeyDown(interactKey))
            {
                interactableLeft[0].GetComponent<MoveableMovement>().isControlled = true;
            }
        }
        else if(interactableUp.Length > 0)
        {
            if(Input.GetKeyDown(interactKey))
            {
                interactableUp[0].GetComponent<MoveableMovement>().isControlled = true;
            }
        }
        else if(interactableDown.Length > 0)
        {
            if(Input.GetKeyDown(interactKey))
            {
                interactableDown[0].GetComponent<MoveableMovement>().isControlled = true;
            }
        }


        if (Vector3.Distance(transform.position, movePoint.position) <= .05f)
        {
            if (Mathf.Abs(Input.GetAxisRaw("Horizontal")) == 1)
            {
                if (canWalkX)
                {
                    movePoint.position += new Vector3(Input.GetAxisRaw("Horizontal"), 0f, 0f); //Move Left/Right
                }
                else if (canWalkStairX)
                {
                    if(stairsX[0].GetComponent<MoveableMovement>().groundRight.Length > 0)
                    {
                        if (transform.position.y - 0.25f == stairsX[0].transform.position.y)
                        {
                            movePoint.position += new Vector3(Input.GetAxisRaw("Horizontal") + 1f, 1f, 0f); //Move Upstairs
                        }
                        else
                        {
                            movePoint.position += new Vector3(Input.GetAxisRaw("Horizontal") - 1f, -1f, 0f); //Move Downstairs
                        }
                    }
                    else if(stairsX[0].GetComponent<MoveableMovement>().groundLeft.Length > 0)
                    {
                        if (transform.position.y - 0.25f == stairsX[0].transform.position.y)
                        {
                            movePoint.position += new Vector3(Input.GetAxisRaw("Horizontal") - 1f, 1f, 0f); //Move Upstairs
                        }
                        else
                        {
                            movePoint.position += new Vector3(Input.GetAxisRaw("Horizontal") + 1f, -1f, 0f); //Move Downstairs
                        }
                    }
                }
            }
            else if (Mathf.Abs(Input.GetAxisRaw("Vertical")) == 1)
            {
                if (canWalkZ)
                {
                    movePoint.position += new Vector3(0f, 0f, Input.GetAxisRaw("Vertical")); //Move Forward/Backward
                }
                else if (canWalkStairZ)
                {
                    if(stairsZ[0].GetComponent<MoveableMovement>().groundUp.Length > 0)
                    {
                        if (transform.position.y - 0.25f == stairsZ[0].transform.position.y)
                        {
                            movePoint.position += new Vector3(0f, 1f, Input.GetAxisRaw("Vertical") + 1f); //Move Upstairs
                        }
                        else
                        {
                            movePoint.position += new Vector3(0f, -1f, Input.GetAxisRaw("Vertical") - 1f); //Move Downstairs
                        }
                    }
                    else if(stairsZ[0].GetComponent<MoveableMovement>().groundDown.Length > 0)
                    {
                        if (transform.position.y - 0.25f == stairsZ[0].transform.position.y)
                        {
                            movePoint.position += new Vector3(0f, 1f, Input.GetAxisRaw("Vertical") - 1f); //Move Upstairs
                        }
                        else
                        {
                            movePoint.position += new Vector3(0f, -1f, Input.GetAxisRaw("Vertical") + 1f); //Move Downstairs
                        }
                    }
                }
            }
        }
    }
}
