using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.InputSystem;
using UnityEngine.InputSystem.LowLevel;
using UnityEngine.EventSystems;

public class ObjectMover : MonoBehaviour
{
    [SerializeField] GameObject moveObject;

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
        
        if (!twoTouchState) {
            // resume rotation
            GetComponent<ObjectRotor>().enabled = true;
            return;
        }
        
        Vector2 pos0 = _touchState0.position;
        Vector2 pos1 = _touchState1.position;
        Vector2 oldPos0 = pos0 - _touchState0.delta;
        Vector2 oldPos1 = pos1 - _touchState1.delta;

        if ( PointIsOverUI(pos0) || PointIsOverUI(pos1) || PointIsOverUI(oldPos0) || PointIsOverUI(oldPos1) ) {
            // resume rotation
            GetComponent<ObjectRotor>().enabled = true;
            return;
        }

        // pause rotation
        GetComponent<ObjectRotor>().enabled = false;

        Vector3 delta0 = Camera.main.ScreenToWorldPoint(new Vector3(pos0.x, pos0.y, 1)) 
            - Camera.main.ScreenToWorldPoint(new Vector3(oldPos0.x, oldPos0.y, 1));
        Vector3 delta1 = Camera.main.ScreenToWorldPoint(new Vector3(pos1.x, pos1.y, 1)) 
            - Camera.main.ScreenToWorldPoint(new Vector3(oldPos1.x, oldPos1.y, 1));
        Vector3 delta = (delta0+delta1)/2;

        float scale = Mathf.Sqrt( (pos0-pos1).magnitude/(oldPos0-oldPos1).magnitude );

        gameObject.transform.position += delta;
        gameObject.transform.localScale *= scale;
        
    }
    
    // Check if a given screen position is on a UI component
    // from tonemcbride's post in https://forum.unity.com/threads/special-action-for-touching-ui-element.429247/ 
    private static List<RaycastResult> tempRaycastResults = new List<RaycastResult>();
 
    public bool PointIsOverUI(Vector2 v)
    {
        var eventDataCurrentPosition = new PointerEventData(EventSystem.current); 
        eventDataCurrentPosition.position = v;  
        tempRaycastResults.Clear();
        EventSystem.current.RaycastAll(eventDataCurrentPosition, tempRaycastResults);

        return tempRaycastResults.Count > 0;
    }
    
    // Start is called before the first frame update
    void Start()
    {
        if (moveObject == null) {
            moveObject = gameObject;
        }
    }

    // Update is called once per frame
    void Update()
    {
        OnTwoFingerSwipe();
    }

}
