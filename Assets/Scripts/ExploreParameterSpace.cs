using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.LowLevel;
using UnityEngine.UI;

public class ExploreParameterSpace : MonoBehaviour
{
    public float scrollSpeed = 5;
    public float zoomSpeed = 5;

#if UNITY_WEBGL
    float speedscale = 0.001f*0.003f;
#else
    float speedscale = 0.001f;
#endif

    Material material;

    // Start is called before the first frame update
    void Start()
    {
        // duplicate material
        material = new Material(GetComponent<Image>().material);
        GetComponent<Image>().material = material;
    }

    public void Reset()
    {
        material = GetComponent<Image>().material;
    }
    
    // Update is called once per frame
    void Update()
    {
        // mouse controls
        var mouse = Mouse.current;
        if (mouse == null) return;

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
                float magnitude = Mathf.Exp(scroll.y * zoomSpeed * speedscale);
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
                scroll *= scrollSpeed * speedscale;

                float dx = width * scroll.x,
                    dy = height * scroll.y;
                material.SetFloat("_XMin", x0 + dx);
                material.SetFloat("_XMax", x1 + dx);
                material.SetFloat("_YMin", y0 + dy);
                material.SetFloat("_YMax", y1 + dy);
            }
        }
    }

    void LateUpdate() {
        OnTwoFingerSwipe();    
    }

    private TouchState _touchState0;
    private TouchState _touchState1;
    public void OnTouch0(InputAction.CallbackContext context) {
        _touchState0 = context.ReadValue<TouchState>();
        // Debug.Log("Primary Touch position: " + _touchState0.position );
        // OnTwoFingerSwipe();
    }
    
    public void OnTouch1(InputAction.CallbackContext context) {
        _touchState1 = context.ReadValue<TouchState>();
        // Debug.Log("Primary Touch position: " + _touchState0.position );
        //OnTwoFingerSwipe();
    }

    private void OnTwoFingerSwipe() {
        
        bool twoTouchState = ( (_touchState0.phase == UnityEngine.InputSystem.TouchPhase.Moved) && (_touchState1.isInProgress) || 
                             ( (_touchState0.isInProgress) && (_touchState1.phase == UnityEngine.InputSystem.TouchPhase.Moved) ) );
        
        var pickParameter = this.GetComponent<PickParameter>();
        if (!twoTouchState ) 
        {
            if (pickParameter != null) { pickParameter.enabled = true; }
            return;
        }

        pickParameter.enabled = false;

        Vector2 pos0 = _touchState0.position;
        Vector2 pos1 = _touchState1.position;
        Vector2 oldPos0 = pos0 - _touchState0.delta;
        Vector2 oldPos1 = pos1 - _touchState1.delta;


        Vector2 mid = (pos0+pos1)/2;
        Vector2 oldMid = (oldPos0+oldPos1)/2;
        float scale = Mathf.Sqrt( (oldPos0-oldPos1).magnitude/(pos0-pos1).magnitude );

        var rect = GetComponent<RectTransform>().rect;
        Vector2 localPos = transform.InverseTransformPoint(pos0);
        Vector2 pixelUV0 = new Vector2(localPos.x / rect.width, -localPos.y / rect.height);

        if ((pixelUV0.x < 0) || (pixelUV0.x > 1) || (pixelUV0.y < 0) || (pixelUV0.y > 1) ) return;

        localPos = transform.InverseTransformPoint(pos1);
        Vector2 pixelUV1 = new Vector2(localPos.x / rect.width, -localPos.y / rect.height);

        if ( (pixelUV1.x < 0) || (pixelUV1.x > 1) || (pixelUV1.y < 0) || (pixelUV1.y > 1) ) return;

        localPos = transform.InverseTransformPoint(mid);
        Vector2 pixelUVMid = new Vector2(localPos.x / rect.width, -localPos.y / rect.height);

        localPos = transform.InverseTransformPoint(oldMid);
        Vector2 pixelUVOldMid = new Vector2(localPos.x / rect.width, -localPos.y / rect.height);

        float x0 = material.GetFloat("_XMin"),
              x1 = material.GetFloat("_XMax"),
              y0 = material.GetFloat("_YMin"),
              y1 = material.GetFloat("_YMax");
            
        Vector2 center = new Vector2(x0*(1-pixelUVOldMid.x) + x1*pixelUVOldMid.x, 
                                     y0*pixelUVOldMid.y + y1*(1-pixelUVOldMid.y));

        float xscale = scale*(x1-x0), yscale = scale*(y1-y0);
        float X0 = xscale*(-pixelUVMid.x) + center.x,
              Y0 = yscale*(pixelUVMid.y-1) + center.y,
              X1 = X0 + xscale, Y1 = Y0 + yscale;

        material.SetFloat("_XMin", X0);
        material.SetFloat("_XMax", X1);
        material.SetFloat("_YMin", Y0);
        material.SetFloat("_YMax", Y1);

    }

}

