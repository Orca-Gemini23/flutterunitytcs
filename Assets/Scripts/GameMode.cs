using System;
using FlutterUnityIntegration;
using TMPro;
using UnityEngine;
using UnityEngine.Serialization;

public abstract class GameMode : MonoBehaviour
{
    protected static long SessionID = DateTimeOffset.Now.ToUnixTimeMilliseconds();
    public float currentLeftAngle;
    public float currentRightAngle;
    [FormerlySerializedAs("LastLeftBeep")] public long lastLeftBeep;

    [FormerlySerializedAs("LastRightBeep")]
    public long lastRightBeep;

    [SerializeField] private TextMeshProUGUI _scoreText;

    public bool inputEnabled;

    protected ActiveLeg activeLeg;

    protected int score;

    public void Start()
    {
        Time.timeScale = 0;
        SessionID = DateTimeOffset.Now.ToUnixTimeMilliseconds();
    }

    protected void Update()
    {
        currentLeftAngle = InputController.CurrentLeftAngle;
        currentRightAngle = InputController.CurrentRightAngle;
        LogData();
    }

    protected void IncrementScore()
    {
        score++;
        _scoreText.text = score.ToString();
    }

    protected abstract void LogData();

    protected void Vibrate()
    {
        switch (activeLeg)
        {
            case ActiveLeg.Left:
                lastLeftBeep = DateTimeOffset.Now.ToUnixTimeMilliseconds();
                UnityMessageManager.Instance.SendMessageToFlutter("VL");
                break;
            case ActiveLeg.Right:
                lastRightBeep = DateTimeOffset.Now.ToUnixTimeMilliseconds();
                UnityMessageManager.Instance.SendMessageToFlutter("VR");
                break;
        }
    }

    protected enum ActiveLeg
    {
        Left,
        Right
    }
}