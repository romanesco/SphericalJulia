using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UI;
using TMPro;

public class PickParameter : MonoBehaviour
{
    public GameObject child = null;
    public TextMeshProUGUI parameterDisplay;

    // Start is called before the first frame update
    void Start()
    {
        // duplicate the material of the child
        var material = child.GetComponent<Renderer>().material;
    }

    // Update is called once per frame
    void Update()
    {
        if (child == null) { return; }

        var mouse = Mouse.current;
        if (mouse == null) { return; }
       
        if (mouse.leftButton.isPressed)
        {
            // Debug.Log(Input.mousePosition);
            Vector2 localPos = transform.InverseTransformPoint(Input.mousePosition);
            var rect = GetComponent<RectTransform>().rect;
            Vector2 pixelUV = new Vector2(localPos.x / rect.width, -localPos.y / rect.height);

            if ( (pixelUV.x < 0) || (pixelUV.x > 1) || (pixelUV.y <0) || (pixelUV.y>1) ) { return; }

            Material material = GetComponent<Image>().material;
            float xmin = material.GetFloat("_XMin");
            float xmax = material.GetFloat("_XMax");
            float ymin = material.GetFloat("_YMin");
            float ymax = material.GetFloat("_YMax");
            Vector2 c = new Vector2(xmin + pixelUV.x * (xmax - xmin), ymin + pixelUV.y * (ymax - ymin));

            Material cmaterial = child.GetComponent<Renderer>().sharedMaterial;
            // cmaterial.SetFloat("_CRe", c.x);
            // cmaterial.SetFloat("_CIm", c.y);
            cmaterial.SetFloat("_X", c.x);
            cmaterial.SetFloat("_Y", c.y);

            if (parameterDisplay != null)
            {
                parameterDisplay.text = "Parameter: " + c.ToString("F6");
            }
        }


    }
}
