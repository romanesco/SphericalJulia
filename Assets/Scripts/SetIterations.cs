using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SetIterations : MonoBehaviour
{
    public GameObject dynamicsObject;
    public bool forImage = false;

    Material material;

    private void Start()
    {
        if (dynamicsObject == null)
        {
            dynamicsObject = gameObject;
        }
    }

    public void SetIteration(float i)
    {
        if (forImage)
        {
            material = dynamicsObject.GetComponent<Image>().material;
        }
        else
        {
            material = dynamicsObject.GetComponent<MeshRenderer>().sharedMaterial;
        }
        material.SetInt("_Iteration", (int) i);
    }

    public void SetPreIterations(float i)
    {
        if (forImage)
        {
            material = dynamicsObject.GetComponent<Image>().material;
        }
        else
        {
            material = dynamicsObject.GetComponent<MeshRenderer>().sharedMaterial;
        }
        material.SetInt("_PreIteration", (int) i);
    }
}
