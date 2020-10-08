using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;
using UnityEngine.UI;

public class ObjectSpawnerWizard : ScriptableWizard
{
    public GameObject objectToSpawn;
    public int numberOfObjects;
    private Transform spawnLocation;

    private void Awake()
    {
        spawnLocation = GameObject.Find("SpawnLocation").transform;
    }

    [MenuItem("Custom Tools/Object Spawner")]
    private static void CreateWizard()
    {
        DisplayWizard<ObjectSpawnerWizard>("Spawn object...", "Spawn Object");
    }

    private void OnWizardCreate()
    {
        if (numberOfObjects > 5f)
        {
            Debug.LogError("Please spawn fewer than 5 items at once.");
        }
        else
        {
            for (int i = 0; i < numberOfObjects; i++)
            {
                PrefabUtility.InstantiatePrefab(objectToSpawn);
                objectToSpawn.transform.position = spawnLocation.position;
            }
        }
    }
}
