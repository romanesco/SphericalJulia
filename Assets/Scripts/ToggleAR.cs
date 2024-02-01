using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ToggleAR : MonoBehaviour
{
    public GameObject mainCamera;
    public GameObject ARSet;
    public GameObject sphere;

    Vector3 originalSpherePosition;
    Vector3 originalSphereScale;
    Vector3 ARSpherePosition;
    Vector3 ARSphereScale;

    public bool isAR = false;
    bool wasAR = false;


    // Start is called before the first frame update
    void Start()
    {
        ARSet.SetActive(false);
        mainCamera.SetActive(true);
        originalSpherePosition = sphere.transform.position;
        originalSphereScale = sphere.transform.localScale;
        ARSpherePosition = sphere.transform.position;
        ARSphereScale = sphere.transform.localScale;

    }

    // Update is called once per frame
    void Update()
    {
        /*
        if (isAR != wasAR) {
        // reset the sphere position
        sphere.transform.position = originalSpherePosition;

        ARSet.SetActive(isAR);
        mainCamera.SetActive(!isAR);

        }
        wasAR = isAR;
        */
    }

    public void Toggle() {
        isAR = !isAR; // toggle
        
        if (isAR) {
            // restore the AR position and scale
            sphere.transform.position = ARSpherePosition;
            sphere.transform.localScale = ARSphereScale;
        } else {
            // store the AR position and scale
            ARSpherePosition = sphere.transform.position;
            ARSphereScale = sphere.transform.localScale;

            // reset the sphere position
            sphere.transform.position = originalSpherePosition;
            sphere.transform.localScale = originalSphereScale;
        }

        ARSet.SetActive(isAR);
        mainCamera.SetActive(!isAR);
    }
}
