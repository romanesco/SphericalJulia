using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class SceneChooserGUI : MonoBehaviour
{
    int selGridInt = 0;
    string[] descriptions;
    string[][] sceneList = { 
         new string[] {"QuadPoly", "Quadratic polynomials"},
        new string[] {"Rat2Per2", "Quadratic rational maps with period 2 critical point"},
        new string[] {"RealRat2", "Real quadratic rational maps"}
    };

    void Start()
    {
        // create 
        descriptions = new string[sceneList.Length];
        for (int i=0; i<sceneList.Length; i++)
        {
            descriptions[i] = sceneList[i][1];
        }

    }
    bool showChooserDialog = false;

    void OnGUI() {
        if (GUI.Button(new Rect(Screen.width - 180, Screen.height-50,150,30), "Change function")) 
        {
            showChooserDialog = true;
        }

        if (showChooserDialog) {
            GUI.BeginGroup (new Rect (Screen.width / 2 - 200, Screen.height / 2 - 200, 400, 400));
        
            GUI.Box (new Rect (0,0,400,400), "Choose function");
            //GUI.Button (new Rect (10,40,80,30), "Click me");
            GUILayout.BeginVertical("Box");
            selGridInt = GUILayout.SelectionGrid(selGridInt, descriptions, 1);
            GUILayout.BeginHorizontal();
            if (GUILayout.Button("Change function"))
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
            if (GUILayout.Button("Cancel")) 
            {
                showChooserDialog = false;
            }
            GUILayout.EndHorizontal();
            GUILayout.EndVertical();
            GUI.EndGroup ();
        }
    }
}
