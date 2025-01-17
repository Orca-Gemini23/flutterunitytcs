using System.Collections;
using FlutterUnityIntegration;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Serialization;
using UnityEngine.UI;

internal class SceneController : MonoBehaviour
{
    public enum Leg
    {
        Left,
        Right
    }


    public const int TargetScore = 10;


    // instance
    [FormerlySerializedAs("StartButton")] [SerializeField]
    private Button startButton;

    [FormerlySerializedAs("LegIndicator")] [SerializeField]
    public Image legIndicator;

    [SerializeField] private Sprite leftLegSprite;
    [SerializeField] private Sprite rightLegSprite;

    [FormerlySerializedAs("GameOver")] [SerializeField]
    private Image gameOver;

    public double latency;


    public double previous;
    public static SceneController Instance { get; private set; }

    private void Awake()
    {
        if (Instance != null && Instance != this)
            Destroy(this);
        else
            Instance = this;
    }

    private void Start()
    {
        Screen.sleepTimeout = SleepTimeout.NeverSleep;
        Screen.orientation = ScreenOrientation.Portrait;
        Instance.gameOver.gameObject.SetActive(false);
    }

    private void OnDestroy()
    {
        Screen.sleepTimeout = SleepTimeout.SystemSetting;
    }

    public void BallGame(string message)
    {
        SceneManager.LoadScene(1);
    }

    public void FishingGame(string message)
    {
        SceneManager.LoadScene(2);
    }

    public void SwingGame(string message)
    {
        SceneManager.LoadScene(3);
    }

    public void TaxiGame(string message)
    {
        SceneManager.LoadScene(4);
    }


    private IEnumerator Test()
    {
        while (true)
            // AccelerometerValue("R : 0.88 0.17 0.47 5.00 0.00 0.00");
            yield return new WaitForSecondsRealtime(0.1f);
    }


    public static IEnumerator VibrateLeft(float delay)
    {
        yield return new WaitForSeconds(delay);
        UnityMessageManager.Instance.SendMessageToFlutter("VL");
    }

    public static IEnumerator VibrateRight(float delay)
    {
        yield return new WaitForSeconds(delay);

        UnityMessageManager.Instance.SendMessageToFlutter("VR");
    }


    public void Resume()
    {
        if (Time.timeScale == 0)
        {
            startButton.GetComponentInChildren<TextMeshProUGUI>().text = "Stop";
            Time.timeScale = 1;
        }
        else
        {
            startButton.GetComponentInChildren<TextMeshProUGUI>().text = "Resume";
            Time.timeScale = 0;
        }
    }

    public static void UpdateScore(int score)
    {
        if (score % TargetScore == 0 && score != 0)
        {
            Time.timeScale = 0;
            Instance.gameOver.gameObject.SetActive(true);
            //TODO put some form of completion here  
        }
    }

    public static void UpdateLeg(Leg leg)
    {
        switch (leg)
        {
            case Leg.Left:
                Instance.legIndicator.sprite = Instance.leftLegSprite;
                Instance.legIndicator.gameObject.GetComponentInChildren<TextMeshProUGUI>().text = "Left";
                break;
            case Leg.Right:
                Instance.legIndicator.sprite = Instance.rightLegSprite;
                Instance.legIndicator.gameObject.GetComponentInChildren<TextMeshProUGUI>().text = "Right";
                break;
        }
    }

    public void Continue()
    {
        Time.timeScale = 1;
        gameOver.gameObject.SetActive(false);
    }

    public void ExitGame()
    {
        UnityMessageManager.Instance.SendMessageToFlutter("Exit");
        SceneManager.LoadScene(0);
    }
}