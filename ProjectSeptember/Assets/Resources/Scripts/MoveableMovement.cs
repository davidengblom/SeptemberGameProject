using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveableMovement : MonoBehaviour
{
    [Header("Components")]
    [Tooltip("The indicator that the player is constantly moving towards.")]
    public Transform movePoint;

    public CharacterMovement playerMovement;
    public Outliner outliner;

    [Header("Variables")]
    [Tooltip("The speed at which the player moves.")]
    public float moveSpeed = 5f;

    private LayerMask moveableLayer;
    private LayerMask stairs;
    private LayerMask ground;

    private bool canMoveX;
    private bool canMoveZ;

    public bool isControlled = false;

    [HideInInspector] public Collider[] groundRight;
    [HideInInspector] public Collider[] groundLeft;
    [HideInInspector] public Collider[] groundUp;
    [HideInInspector] public Collider[] groundDown;

    private void Start()
    {
        movePoint.parent = null;
        moveableLayer = LayerMask.GetMask("Moveable");
        stairs = LayerMask.GetMask("Stairs");
        ground = LayerMask.GetMask("Ground");

        playerMovement = GameObject.FindGameObjectWithTag("Player").GetComponent<CharacterMovement>();
        outliner = GetComponent<Outliner>();
    }

    private void FixedUpdate()
    {
        if(transform.position != movePoint.position)
        {
            transform.position = Vector3.MoveTowards(transform.position, movePoint.position, moveSpeed * Time.deltaTime);
        }
    }

    private void Update()
    {
        canMoveX = Physics.CheckSphere(movePoint.position + new Vector3(Input.GetAxisRaw("Horizontal"), -0.75f, 0f), 0.2f, moveableLayer);
        canMoveZ = Physics.CheckSphere(movePoint.position + new Vector3(0f, -0.75f, Input.GetAxisRaw("Vertical")), 0.2f, moveableLayer);

        Collider[] stairsX = Physics.OverlapSphere(movePoint.position + new Vector3(Input.GetAxisRaw("Horizontal"), -0.75f, 0f), 0.2f, stairs);
        Collider[] stairsZ = Physics.OverlapSphere(movePoint.position + new Vector3(0f, -0.75f, Input.GetAxisRaw("Vertical")), 0.2f, stairs);

        groundRight = Physics.OverlapSphere(transform.position + new Vector3(1f, 0.75f, 0), 0.2f, ground); //If none of these are true then the player cant use the stairs
        groundLeft = Physics.OverlapSphere(transform.position + new Vector3(-1f, 0.75f, 0), 0.2f, ground);
        groundUp = Physics.OverlapSphere(transform.position + new Vector3(0f, 0.75f, 1f), 0.2f, ground);
        groundDown = Physics.OverlapSphere(transform.position + new Vector3(0f, 0.75f, -1f), 0.2f, ground);
        
        if(isControlled)
        {
            outliner.CreateOutline();
            playerMovement.enabled = false;

            if(Input.GetKeyDown(KeyCode.E))
            {
                playerMovement.enabled = true;
                isControlled = false;
            }
            if (Vector3.Distance(transform.position, movePoint.position) <= 0.05f)
            {
                if (Mathf.Abs(Input.GetAxisRaw("Horizontal")) == 1)
                {
                    if (canMoveX)
                    {
                        if (stairsX.Length <= 0)
                        {
                            movePoint.position += new Vector3(Input.GetAxisRaw("Horizontal"), 0f, 0f);
                        }
                    }
                }
                else if (Mathf.Abs(Input.GetAxisRaw("Vertical")) == 1)
                {
                    if (canMoveZ)
                    {
                        if (stairsZ.Length <= 0)
                        {
                            movePoint.position += new Vector3(0f, 0f, Input.GetAxisRaw("Vertical"));
                        }
                    }
                }
            }
        }
        else
        {
            playerMovement.enabled = true;
            outliner.DeleteOutline();
        }
        
    }
}
