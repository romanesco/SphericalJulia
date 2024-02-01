using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SetIterations : MonoBehaviour
{
    public GameObject dynamicsObject;
    public bool forImage = false;

    public Slider sliderIteration;
    public Slider sliderPreIteration;

    Material material;

    private void Start()
    {
        if (dynamicsObject == null)
        {
            dynamicsObject = gameObject;
        }
        material = GetMaterial();
    }

    Material GetMaterial()
    {
        if (forImage)
        {
            return dynamicsObject.GetComponent<Image>().material;
        }
        else
        {
            return dynamicsObject.GetComponent<MeshRenderer>().sharedMaterial;
        }
    }

    public void Reset() 
    {
        // reset material
        material = GetMaterial();
        
        // reset iterations
        if (sliderIteration != null) {
            int i = material.GetInt("_Iteration");
            int iMax = material.GetInt("_MaxIteration");
            sliderIteration.value = i;
            sliderIteration.maxValue = iMax;
            Debug.Log("Set iteration to " + i + " and max iteration bound to " + iMax);
        }
        
        if (sliderPreIteration != null) {
            if (material.shader.FindPropertyIndex("_PreIteration") != -1) {
                //sliderPreIteration.enabled = true;
                sliderPreIteration.gameObject.SetActive(true);
                int pi = material.GetInt("_PreIteration");
                int piMax = material.GetInt("_MaxPreIteration");
                sliderPreIteration.value = pi;
                sliderPreIteration.maxValue = piMax;
            } else {
                // sliderPreIteration.enabled = false;
                sliderPreIteration.gameObject.SetActive(false);
            }
        }
    }

    public void SetIteration(float i)
    {
        material.SetInt("_Iteration", (int) i);
    }

    public void SetPreIterations(float i)
    {
        material.SetInt("_PreIteration", (int) i);
    }
}
