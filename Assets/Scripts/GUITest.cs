using UnityEngine;
using System.Collections;

public class GUITest : MonoBehaviour {
    
    void OnGUI () {
        // Make a group on the center of the screen
        GUI.BeginGroup (new Rect (Screen.width / 2 - 50, Screen.height / 2 - 50, 100, 100));
        // All rectangles are now adjusted to the group. (0,0) is the topleft corner of the group.
    
        // We'll make a box so you can see where the group is on-screen.
        GUI.Box (new Rect (0,0,100,100), "Group is here");
        GUI.Button (new Rect (10,40,80,30), "Click me");
    
        // End the group we started above. This is very important to remember!
        GUI.EndGroup ();
    }


}

