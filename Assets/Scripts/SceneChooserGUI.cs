using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UIElements;

public class SceneChooserGUI : MonoBehaviour
{
    int selGridInt = 0;
    string[] descriptions;
    string[][] sceneList = { 
         new string[] {"QuadPoly", "Quadratic polynomials"},
        new string[] {"Rat2Per2", "Quadratic rational maps with period 2 critical point"},
        new string[] {"RealRat2", "Real quadratic rational maps"}
    };

    GUIStyle style;

    void Start()
    {
        // create list of descriptions
        descriptions = new string[sceneList.Length];
        for (int i=0; i<sceneList.Length; i++)
        {
            descriptions[i] = sceneList[i][1];
        }

        style = new GUIStyle();
        style.fontSize = 100;
    }
    bool showChooserDialog = false;

    void OnGUI() {
        GUI.skin.button.fontSize = 32;
        GUI.skin.box.fontSize = 40;

        if (GUI.Button(new Rect(Screen.width - 320, Screen.height-80,300,60), "Change function")) 
        {
            showChooserDialog = true;
        }

        if (showChooserDialog) {
            int w = 800, h = 600;
            GUI.BeginGroup (new Rect (Screen.width / 2 - w/2, Screen.height / 2 - h/2, w, h));
        
            //GUI.Box (new Rect (0,0,w,50), "Choose function", style);
            //GUI.Button (new Rect (10,40,80,30), "Click me");
            GUILayout.BeginVertical("Box", GUILayout.Width(w));
            GUILayout.Box("Choose function");
            selGridInt = GUILayout.SelectionGrid(selGridInt, descriptions, 1, GUILayout.Height(200));
            GUILayout.Space(28);
            GUILayout.BeginHorizontal();
            if (GUILayout.Button("Change function", GUILayout.Height(100)))
            {
                string nextSceneName = sceneList[selGridInt][0];
                string sceneName = SceneManager.GetActiveScene().name;
                int l = sceneName.Length;
                if ((l>2) && (sceneName.Substring(l-3) == "_AR")) {
                    nextSceneName += "_AR";
                }
                Debug.Log("You chose " + nextSceneName);
                SceneManager.LoadScene(nextSceneName);
            }
            if (GUILayout.Button("Cancel",GUILayout.Height(100)))
            {
                showChooserDialog = false;
            }
            GUILayout.EndHorizontal();
            GUILayout.EndVertical();
            GUI.EndGroup ();
        }
    }
}
