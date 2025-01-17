using System;
using System.Collections;
using System.IO;
using TMPro;
using UnityEngine;

public class SwingGameManager : GameMode
{
    public bool left;
    public GameObject springArm;
    public GameObject rightLeg;
    public GameObject leftLeg;
    public GameObject fakeRightLeg;
    public GameObject fakeLeftLeg;
    public bool reverse;
    public float time;
    public GameObject backgroundImage;

    public float swingTime = 1.5f;

    public bool leftForward;
    public GameObject DirectionImage;
    public Sprite leftSprite;
    public Sprite rightSprite;

    // Update is called once per frame


    public int score;
    public TextMeshProUGUI scoreText;
    public TextMeshProUGUI starText;

    public float stars;

    private int count;
    private float delay;
    private long lastBeepLeft;
    private long lastBeepRight;
    private float rot;

    private long timestamp_time;

    // public AudioClip reel;


    private new void Start()
    {
        base.Start();

        StartCoroutine(Vibration());
        StartCoroutine(CollectData());
    }


    private new void Update()
    {
        base.Update();
        if (delay > 0)
            delay -= Time.deltaTime;

        currentLeftAngle = Mathf.Clamp(currentLeftAngle, 0, 90);
        currentRightAngle = Mathf.Clamp(currentRightAngle, 0, 90);
        if (Mathf.Floor(count / 4f) % 2 == 0)
        {
            left = true;
            rightLeg.transform.localEulerAngles = new Vector3(0, 0, 0);

            if (!reverse)
            {
                time += Time.deltaTime / swingTime;
                fakeLeftLeg.transform.localRotation = Quaternion.Euler(0, 0, Mathf.SmoothStep(0, 90, time));
                if (fakeLeftLeg.transform.localRotation.eulerAngles.z >= 90)
                {
                    reverse = true;
                    time = 0;
                }
            }
            else
            {
                time += Time.deltaTime / swingTime;
                fakeLeftLeg.transform.localRotation = Quaternion.Euler(0, 0, Mathf.SmoothStep(90, 0, time));
                if (fakeLeftLeg.transform.localRotation.eulerAngles.z <= 0)
                {
                    reverse = false;
                    count++;
                    time = 0;
                }
            }
        }
        else
        {
            left = false;
            leftLeg.transform.localEulerAngles = new Vector3(0, 0, 0);
            if (!reverse)
            {
                time += Time.deltaTime / swingTime;
                fakeRightLeg.transform.localRotation = Quaternion.Euler(0, 0, Mathf.SmoothStep(0, 90, time));
                if (fakeRightLeg.transform.localRotation.eulerAngles.z >= 90)
                {
                    reverse = true;
                    time = 0;
                }
            }
            else
            {
                time += Time.deltaTime / swingTime;
                fakeRightLeg.transform.localRotation = Quaternion.Euler(0, 0, Mathf.SmoothStep(90, 0, time));
                if (fakeRightLeg.transform.localRotation.eulerAngles.z <= 0)
                {
                    count++;
                    reverse = false;
                    time = 0;
                }
            }
        }

        if (left)
            leftLeg.transform.localEulerAngles = new Vector3(0, 0, currentLeftAngle);
        else
            rightLeg.transform.localEulerAngles = new Vector3(0, 0, currentRightAngle);

        rot = left ? fakeLeftLeg.transform.localEulerAngles.z - 45 : fakeRightLeg.transform.localEulerAngles.z - 45;
        springArm.transform.localEulerAngles = new Vector3(0, 0, rot / 3);
        backgroundImage.transform.localPosition = new Vector2(-rot * 5, 0);
        if (left)
            SceneController.UpdateLeg(SceneController.Leg.Left);
        // DirectionImage.GetComponent<UnityEngine.UI.Image>().sprite=leftSprite;
        else
            SceneController.UpdateLeg(SceneController.Leg.Right);
        // DirectionImage.GetComponent<UnityEngine.UI.Image>().sprite=rightSprite;
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        if (delay <= 0)
            UpdateScore();
    }

    protected override void LogData()
    {
    }

    private IEnumerator Vibration()
    {
        yield return new WaitForSeconds(0.1f);
        while (true)
        {
//            Debug.Log("vibrate");
            if (left)
            {
                fakeLeftLeg.SetActive(true);
                fakeRightLeg.SetActive(false);
                lastBeepLeft = DateTimeOffset.Now.ToUnixTimeMilliseconds();
                StartCoroutine(SceneController.VibrateLeft(0));
            }
            else
            {
                fakeLeftLeg.SetActive(false);
                fakeRightLeg.SetActive(true);
                lastBeepRight = DateTimeOffset.Now.ToUnixTimeMilliseconds();
                StartCoroutine(SceneController.VibrateRight(0));
            }

            yield return new WaitForSeconds(3 + Time.deltaTime);
        }
    }
    // public  

    private void UpdateScore()
    {
        delay = 1.5f;
        score++;
        scoreText.text = "Score\n<b>" + score + "/10</b>";
        starText.text = stars.ToString();
        SceneController.UpdateScore(score);
    }

    private IEnumerator CollectData()
    {
        timestamp_time = DateTimeOffset.Now.ToUnixTimeMilliseconds();
        var dataInString =
            "LeftLegPosx,LeftLegPosy,LeftLegPosz,RightLegPosx,RightLegPosy,RightLegPosz,FakeLeftLegPosx,FakeLeftLegPosy,FakeLeftLegPosz,FakeRightLegPosx,FakeRightLegPosy,FakeRightLegPosz,LeftAngle,RightAngle,Time,LastLeftBeep,LastRightBeep,ALx,ALy,ALz,ARx,ARy,ARz,GLx,GLy,GLz,GRx,GRy,GRz,score,SessionID\n";
        File.AppendAllText(Application.persistentDataPath + $"/swing{timestamp_time}.csv", dataInString);

        while (true)
        {
            var data = new SwingData();
            data.LeftLegPos = leftLeg.transform.position;
            data.RightLegPos = rightLeg.transform.position;
            data.FakeLeftLegPos = fakeLeftLeg.transform.position;
            data.FakeRightLegPos = fakeRightLeg.transform.position;
            data.LeftAngle = currentLeftAngle;
            data.RightAngle = currentRightAngle;
            data.Time = DateTimeOffset.Now.ToUnixTimeMilliseconds();
            data.LastLeftBeep = lastBeepLeft;
            data.LastRightBeep = lastBeepRight;
            // data.AccelerometerL = currentAccL;
            // data.AccelerometerR = currentAccR;
            // data.GyroscopeL = currentGyroL;
            // data.GyroscopeR = currentGyroR;
            data.score = score;
            File.AppendAllText(Application.persistentDataPath + $"/swing{timestamp_time}.csv",
                data.ToString().Replace("(", "").Replace(")", ""));
            yield return new WaitForSeconds(0);
        }
    }

    private struct SwingData
    {
        public Vector3 RightLegPos;
        public Vector3 LeftLegPos;

        public Vector3 FakeRightLegPos;
        public Vector3 FakeLeftLegPos;

        public float LeftAngle;
        public float RightAngle;

        public long Time;

        public long LastLeftBeep;
        public long LastRightBeep;

        public Vector3 AccelerometerL;
        public Vector3 AccelerometerR;

        public Vector3 GyroscopeL;
        public Vector3 GyroscopeR;

        public int score;

        // Adjust this as required
        public override string ToString()
        {
            return
                $"{RightLegPos},{LeftLegPos},{FakeRightLegPos},{FakeLeftLegPos},{LeftAngle},{RightAngle},{Time},{LastLeftBeep},{LastRightBeep},{AccelerometerL},{AccelerometerR},{GyroscopeL},{GyroscopeR},{score},{SessionID}\n";
        }
    }
}