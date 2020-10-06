using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEditor;

public class LevelManagerWizard : ScriptableWizard
{
    private GameObject stairPathParent;
    private GameObject floorParent;

    private void Awake()
    {
        stairPathParent = GameObject.Find("StairWalkables");
        floorParent = GameObject.Find("FloorPieces");
    }

    [MenuItem("Custom Tools/Level Manager")]
    private static void CreateWizard()
    {
        DisplayWizard<LevelManagerWizard>("Manage level", "Remove Stair Path", "Remove Floor");
    }

    private void OnWizardCreate()
    {
        int childCount = stairPathParent.transform.childCount;
        for (int i = childCount - 1; i >= 0; i--)
        {
            DestroyImmediate(stairPathParent.transform.GetChild(i).gameObject);
        }
    }

    private void OnWizardOtherButton()
    {
        int childCount = floorParent.transform.childCount;
        for (int i = childCount - 1; i >= 0; i--)
        {
            DestroyImmediate(floorParent.transform.GetChild(i).gameObject);
        }
    }
}
