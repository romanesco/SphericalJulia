using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FollowParameterLocation : MonoBehaviour
{
    public GameObject child = null;
    public GameObject cross;
    // Start is called before the first frame update
    void Start()
    {
        SetCrossPosition();
    }

    // Update is called once per frame
    void Update()
    {
        SetCrossPosition();
    }

    void SetCrossPosition()
    {
        Material material = GetComponent<Image>().material;
        float xmin = material.GetFloat("_XMin");
        float xmax = material.GetFloat("_XMax");
        float ymin = material.GetFloat("_YMin");
        float ymax = material.GetFloat("_YMax");

        Material cmaterial = child.GetComponent<Renderer>().sharedMaterial;
        float cRe = cmaterial.GetFloat("_X");
        float cIm = cmaterial.GetFloat("_Y");

        var rect = GetComponent<RectTransform>().rect;

        float x = (cRe-xmin)/(xmax-xmin) * rect.width;
        float y = (cIm-ymin)/(ymax-ymin) * rect.height;
    
        cross.transform.localPosition = new Vector3(x, -(rect.height-y), 0);
        // Debug.Log("x: " + x + ", y: " + y );
    }

}
