using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UI;
using TMPro;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem.UI;

public class PickParameter : MonoBehaviour
{
    public GameObject child = null;
    public TextMeshProUGUI parameterDisplay;

    Material material;
    Material cmaterial;
    // Start is called before the first frame update
    void Start()
    {
        material = GetComponent<Image>().material;

        // duplicate the material of the child
        cmaterial = child.GetComponent<Renderer>().material;

        SetParameterText();
    }

    public void Reset() 
    {
        material = GetComponent<Image>().material;
        cmaterial = child.GetComponent<Renderer>().sharedMaterial;

        SetParameterText();
    }
    
    void SetParameterText() 
    {
        float x = cmaterial.GetFloat("_X");
        float y = cmaterial.GetFloat("_Y");

        if (parameterDisplay != null)
        {
            parameterDisplay.text = "Parameter: " + new Vector2(x,y).ToString("F6");
        }

    }

    // Update is called once per frame
    void Update()
    {
        if (child == null) { return; }

        var uiInputModule = (InputSystemUIInputModule) EventSystem.current.currentInputModule;
        if  (uiInputModule == null) { return; }

        if ( uiInputModule.leftClick.action.IsPressed() )
        {
            Vector2 localPos = transform.InverseTransformPoint(uiInputModule.point.action.ReadValue<Vector2>());
                        
            var rect = GetComponent<RectTransform>().rect;
            //Vector2 pixelUV = new Vector2(localPos.x / rect.width, -localPos.y / rect.height);
            Vector2 pixelUV = new Vector2(localPos.x / rect.width, -localPos.y / rect.height);
            // Debug.Log("Pick parameter: " + pixelUV);
            
            if ( (pixelUV.x < 0) || (pixelUV.x > 1) || (pixelUV.y <0) || (pixelUV.y>1) ) { return; }
            
            float xmin = material.GetFloat("_XMin");
            float xmax = material.GetFloat("_XMax");
            float ymin = material.GetFloat("_YMin");
            float ymax = material.GetFloat("_YMax");
            Vector2 c = new Vector2(xmin + pixelUV.x * (xmax - xmin), ymax - pixelUV.y * (ymax - ymin));

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
