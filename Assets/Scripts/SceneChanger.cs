using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
 
public class SceneChanger : MonoBehaviour
{
    [SerializeField] string nextSceneName;


    public void ChangeScene() {
        SceneManager.LoadScene(nextSceneName);
    }
 
}
