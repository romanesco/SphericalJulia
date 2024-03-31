using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class FamilyChooser : MonoBehaviour
{
    [SerializeField] GameObject sphere;
    [SerializeField] GameObject parameterImage;

    int selGridInt = 0;
    public string[] descriptions;
    public Material[] parameterMaterials;
    public Material[] sphereMaterials;

    string[][] sceneList = { 
        new string[] {"QuadPoly", "Quadratic polynomials"},
        new string[] {"Rat2Per2", "Quadratic rational maps with period 2 critical point"},
        new string[] {"RealRat2", "Real quadratic rational maps"}
    };

    void Start()
    {
        /*
        // create list of descriptions
        descriptions = new string[sceneList.Length];
        for (int i=0; i<sceneList.Length; i++)
        {
            descriptions[i] = sceneList[i][1];
        }
        */

    }
    bool showChooserDialog = false;

    void OnGUI() {
        GUI.skin.button.fontSize = 32;
        GUI.skin.box.fontSize = 40;

        if (GUI.Button(new Rect(Screen.width - 320, Screen.height-80,300,60), "Change family")) 
        {
            showChooserDialog = true;
        }

        if (showChooserDialog) {
            int w = 800, h = 600;
            GUI.BeginGroup (new Rect (Screen.width / 2 - w/2, Screen.height / 2 - h/2, w, h));
        
            GUILayout.BeginVertical("Box", GUILayout.Width(w));
            GUILayout.Box("Choose family");
            selGridInt = GUILayout.SelectionGrid(selGridInt, descriptions, 1, GUILayout.Height(300));
            GUILayout.Space(28);
            GUILayout.BeginHorizontal();
            if (GUILayout.Button("Change family", GUILayout.Height(100)))
            {
                string nextSceneName = descriptions[selGridInt];
                Debug.Log("You chose " + nextSceneName);
                // set materials
                Material pmat = parameterImage.GetComponent<Image>().material = new Material(parameterMaterials[selGridInt]);
                Material smat =  sphere.GetComponent<MeshRenderer>().material = new Material(sphereMaterials[selGridInt]);

                // reset iteretions
                sphere.GetComponent<SetIterations>().Reset();
                parameterImage.GetComponent<SetIterations>().Reset();
                // reset ExploreParameterSpace
                parameterImage.GetComponent<ExploreParameterSpace>().Reset();
                // reset PickParameter
                parameterImage.GetComponent<PickParameter>().Reset();

                // close the dialog
                showChooserDialog = false;
            }
            if (GUILayout.Button("Cancel",GUILayout.Height(100)))
            {
                // close the dialog
                showChooserDialog = false;
            }
            GUILayout.EndHorizontal();
            GUILayout.EndVertical();
            GUI.EndGroup ();
        }
    }
}
