using System;
using System.Collections;
using System.Collections.Generic;
using TMPro;
using UnityEngine;
using UnityEngine.UI;

public class SetText : MonoBehaviour
{
    public TMP_Text text;
    public Slider slider;

     private void Start()
    {
        if (text == null)
        {
            text = gameObject.GetComponent<TMP_Text>();
        }
        if (slider != null) {
            SetValue(slider.value);
        }
    }

    public void SetValue(float n)
    {
        text.SetText( ((int) n).ToString());
    }

    public void SetTextValue(string s)
    {
        text.SetText(s);
    }

}
