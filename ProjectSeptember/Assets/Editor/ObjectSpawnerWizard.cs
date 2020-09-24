using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class ObjectSpawnerWizard : ScriptableWizard
{
    public GameObject objectToSpawn;
    public Vector3 spawnCoordinates;

    [MenuItem("Custom Tools/Object Spawner")]
    private static void CreateWizard()
    {
        DisplayWizard<ObjectSpawnerWizard>("Spawn object...", "Spawn Object");
    }

    private void OnWizardCreate()
    {

    }
}
