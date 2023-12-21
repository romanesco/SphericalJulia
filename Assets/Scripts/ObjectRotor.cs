using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.UI;
using UnityEngine.InputSystem.Controls;
using UnityEngine.InputSystem.EnhancedTouch;

public class ObjectRotor : MonoBehaviour
{
    [SerializeField] GameObject rotateObject;
    //public float mouseSensitivity = 0.1f;
    //public float swipeSensitivity = 0.1f;
    public float sensitivity = 0.1f;

    //Matrix4x4 rot = Matrix4x4.identity;

    // Start is called before the first frame update
    void Start()
    {

    }

    Matrix4x4 drot(Vector2 dv)
    {
        float dx = dv.x, dy = dv.y;

        Vector3 axis = new Vector3(dy, -dx, 0);
        float angle = Mathf.Sqrt(dx * dx + dy * dy);
        Quaternion q = Quaternion.AngleAxis(angle, axis);
        Matrix4x4 rot = Matrix4x4.Rotate(q);

        //if (mainCamera != null)
        {
            Matrix4x4 cRot = Matrix4x4.Rotate(Camera.main.transform.rotation);
            // take conjugate
            rot = cRot * rot * Matrix4x4.Transpose(cRot);
        }

        return rot;

    }

    Vector2 oldMousePos;
    Vector2 oldPos;
    
    bool isPressedOutsideUI = false;
    bool isMousePressedOutsideUI = false;
    bool isTouchOutsideUI = false;

    // Update is called once per frame
    void Update()
    {
        Matrix4x4 deltaRot = Matrix4x4.identity;

        var uiInputModule = (InputSystemUIInputModule) EventSystem.current.currentInputModule;
        if  (uiInputModule == null) { return; }

        if (uiInputModule.leftClick.action.IsPressed()) {
            Vector2 pos = uiInputModule.point.action.ReadValue<Vector2>();
            if (!uiInputModule.leftClick.action.WasPressedThisFrame())
            {
                if (isPressedOutsideUI)
                {
                    Vector2 deltaPos = pos - oldPos;
                    deltaRot = drot(deltaPos * sensitivity);
                }
            }
            else
            {
                isPressedOutsideUI = !EventSystem.current.IsPointerOverGameObject();
                Debug.Log("Pressed.  Outside UI pressed: " + isPressedOutsideUI );
            }
            oldPos = pos;
        }

        /*
        var mouse = Mouse.current;
        if (mouse != null)
        {
            int id = mouse.deviceId;

            if (mouse.leftButton.isPressed)
            {
                Vector2 mousePos = mouse.position.ReadValue();

                if (!mouse.leftButton.wasPressedThisFrame)
                {
                    if (isMousePressedOutsideUI)
                    {
                        Vector2 mouseDeltaPos = mousePos - oldMousePos;
                        deltaRot = drot(mouseDeltaPos * mouseSensitivity);
                    }
                }
                else
                {
                    isMousePressedOutsideUI = !EventSystem.current.IsPointerOverGameObject();
                    Debug.Log("Mouse pressed");
                    Debug.Log("Outside UI pressed: " + isMousePressedOutsideUI);
                }
                oldMousePos = mousePos;
            }
        }

        var touchScreen = Touchscreen.current;
        if (touchScreen != null)
        {
            if (touchScreen.touches[0].press.wasPressedThisFrame)
            {
                isTouchOutsideUI = true;

                isTouchOutsideUI = !EventSystem.current.IsPointerOverGameObject();
                if (Input.touches.Length == 1)
                {
                    int id = Input.touches[0].fingerId;
                    isTouchOutsideUI = !EventSystem.current.IsPointerOverGameObject(id);
                }
                Debug.Log("Input.touches.Length: " + Input.touches.Length);
                Debug.Log("Touch outside UI: " + isTouchOutsideUI);
            }


            if (touchScreen.touches[0].press.isPressed && isTouchOutsideUI)
            {
                Vector2 pos = touchScreen.touches[0].delta.ReadValue();
                var dv = pos * swipeSensitivity;
                Debug.Log($"TouchScreen: touch, dv: {dv}");
                deltaRot = drot(dv) * deltaRot;
            }
        }
        */

        if (rotateObject != null)
        {
            rotateObject.transform.rotation = deltaRot.rotation * rotateObject.transform.rotation;
        }
    }
}
