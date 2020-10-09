using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DoorScript : MonoBehaviour
{
    [SerializeField] private Transform connectedDoor;

    private Transform player;
    private Transform playerMovePoint;
    private KeyCode interactKey;
    private bool canEnter = false;

    private void Update()
    {
        if(Input.GetKeyDown(interactKey))
        {
            EnterDoor();
        }
    }

    public void EnterDoor()
    {
        if(connectedDoor == null)
        {
            Debug.LogError("Door is not connected!");
        }

        if(canEnter)
        {
            player.position = connectedDoor.position;
            playerMovePoint.position = player.position;
        }
    }

    private void OnTriggerStay(Collider obj)
    {
        if(obj.CompareTag("Player"))
        {
            canEnter = true;
            player = obj.transform;
            playerMovePoint = obj.transform.GetChild(0);
            interactKey = obj.GetComponent<CharacterMovement>().interactKey;
        }
    }
}
