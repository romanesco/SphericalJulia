using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.UI;

public class ExploreParameterSpace : MonoBehaviour
{
    public float scrollSpeed = 5;
    public float zoomSpeed = 5;

    Material material;

    // Start is called before the first frame update
    void Start()
    {
        // duplicate material
        material = new Material(GetComponent<Image>().material);
        GetComponent<Image>().material = material;
    }


    // Update is called once per frame
    void Update()
    {
        var mouse = Mouse.current;
        Vector2 localPos = transform.InverseTransformPoint(Input.mousePosition);
        var rect = GetComponent<RectTransform>().rect;
        Vector2 pixelUV = new Vector2(localPos.x / rect.width, -localPos.y / rect.height);

        // do nothing outside the image
        if ((pixelUV.x < 0) || (pixelUV.x > 1) || (pixelUV.y < 0) || (pixelUV.y > 1)) { return; }

        Vector2 scroll = mouse.scroll.ReadValue();
        // scroll.y = -scroll.y;

        if (scroll.magnitude > 0.1f)
        {
            // Debug.Log(scroll);
            float x0 = material.GetFloat("_XMin"),
                x1 = material.GetFloat("_XMax"),
                y0 = material.GetFloat("_YMin"),
                y1 = material.GetFloat("_YMax");
            float width = x1 - x0,
                height = y1 - y0;

            if (Keyboard.current.shiftKey.isPressed)
            {
                // shift key + vertical scroll to zoom
                float magnitude = Mathf.Exp(scroll.y * zoomSpeed * 0.001f);
                Vector2 center = new Vector2(pixelUV.x * width + x0, pixelUV.y * height + y0);
                Vector2 v0 = new Vector2(x0, y0), v1 = new Vector2(x1, y1);
                v0 = (v0 - center) * magnitude + center;
                v1 = (v1 - center) * magnitude + center;
                material.SetFloat("_XMin", v0.x);
                material.SetFloat("_XMax", v1.x);
                material.SetFloat("_YMin", v0.y);
                material.SetFloat("_YMax", v1.y);
            }
            else
            {
                scroll *= scrollSpeed * 0.001f;

                float dx = width * scroll.x,
                    dy = height * scroll.y;
                material.SetFloat("_XMin", x0 + dx);
                material.SetFloat("_XMax", x1 + dx);
                material.SetFloat("_YMin", y0 + dy);
                material.SetFloat("_YMax", y1 + dy);
            }


        }
    }
}
