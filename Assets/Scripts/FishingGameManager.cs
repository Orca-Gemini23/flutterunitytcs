using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using TMPro;
using UnityEngine;
using UnityEngine.Animations;
using UnityEngine.Playables;
using UnityEngine.Serialization;
using Button = UnityEngine.UI.Button;
using Image = UnityEngine.UI.Image;

public class FishingGameManager : GameMode
{
    public LineRenderer lineRenderer;

    public GameObject hook;

    //This may need to be adjusted based on the width of the window
    public float totalDistance = 300;
    public float distancePerDegree;
    public Fish currentFish;


    [SerializeField] public List<Fish> fishList = new();

    public bool forcePos = true;

    public AnimationClip struggleAnimation;
    public Image buttonImage;
    public TextMeshProUGUI scoreText;
    public TextMeshProUGUI countText;

    public Image timer;
    [SerializeField] private GameObject fishPrefab;
    [SerializeField] private GameObject redFishPrefab;
    [SerializeField] private AudioClip reel;

    private readonly Dictionary<Vector3, float> availableSlots = new();

    private int _blueFishCount;
//    private readonly List<FishData> _fishData = new();

    private bool _leftLeg = true;

    private int _maxScore;
    // Start is called before the first frame update

    private PlayableGraph _playableGraph;
    private int _redFishCount;
    private int _score;
    private float _time;
    private long timestamp_time;


    private new void Start()
    {
        base.Start();

        _playableGraph = PlayableGraph.Create();
        _playableGraph.SetTimeUpdateMode(DirectorUpdateMode.GameTime);
        distancePerDegree = totalDistance / 90;
        _maxScore = fishList.Count;
        _score = 0;
        UpdateScore();
        UpdateCount();
        SetLegIndicator();
        StartCoroutine(CollectData());
        SceneController.Instance.legIndicator.gameObject.GetComponent<Button>().onClick.AddListener(ChangeLeg);
        SessionID = DateTimeOffset.Now.ToUnixTimeMilliseconds();
    }


    private new void Update()
    {
        base.Update();
        if (forcePos)
        {
            timer.gameObject.transform.parent.gameObject.SetActive(false);
            hook.transform.localPosition = new Vector3(GetCurrentAngle() * distancePerDegree,
                Math.Abs(GetCurrentAngle() * distancePerDegree / Mathf.PI), 0);
        }

        var hookPos = hook.transform.GetChild(0).position;
        lineRenderer.SetPosition(1, new Vector3(hookPos.x, hookPos.y, 1));
        CheckFishes();
    }

    private void OnDestroy()
    {
        _playableGraph.Destroy();
    }

    protected override void LogData()
    {
        // throw new NotImplementedException();
    }


    private void UpdateScore()
    {
        scoreText.text = "Score \n<b>" + _score + "/" + SceneController.TargetScore;
        SceneController.UpdateScore(_score);
    }


    private void CheckFishes()
    {
        if (forcePos)
            foreach (var fish in fishList)
            {
                if (!fish.fishGameObject)
                {
                    fishList.Remove(fish);
                    return;
                }

                if (Math.Abs(fish.angle - GetCurrentAngle()) < 10)
                {
                    var pos = fish.fishGameObject.transform.localPosition;
                    forcePos = false;
                    Struggle(fish);
                    hook.transform.localPosition = fish.fishGameObject.transform.localPosition;
                    fish.fishGameObject.transform.parent = hook.transform;
                    StartCoroutine(CatchFish(fish, pos));
                }
            }
    }

    private void Struggle(Fish fish)
    {
        var playableOutput =
            AnimationPlayableOutput.Create(_playableGraph, "Animation", fish.fishGameObject.GetComponent<Animator>());
        var clipPlayable = AnimationClipPlayable.Create(_playableGraph, struggleAnimation);
        playableOutput.SetSourcePlayable(clipPlayable);
        _playableGraph.Play();
    }

    private IEnumerator CatchFish(Fish fish, Vector3 pos)
    {
        StartTimer();
        _time = 0;
        while (Math.Abs(fish.angle - GetCurrentAngle()) < 12.5f)
        {
            // if (audioSoruce.isPlaying == false)
            // {
            //     audioSoruce.clip = reel;
            //     audioSoruce.Play();
            // }

            _time += Time.deltaTime;
            timer.fillAmount = _time / 4;
            timer.GetComponentInChildren<TextMeshProUGUI>().text = (int)(4 - _time) + "";

            if (_time >= 4)
            {
                FishCaught(fish, pos);
                break;
            }

            if (_time >= 2)
                hook.transform.position =
                    Vector2.MoveTowards(hook.transform.position, lineRenderer.GetPosition(0), Time.deltaTime * 3);

            yield return new WaitForSeconds(0);
        }

        // audioSoruce.Stop();

        forcePos = true;
        if (fish.fishGameObject)
        {
            _playableGraph.Stop();
            fish.fishGameObject.transform.parent = hook.transform.parent;
            fish.fishGameObject.transform.localPosition = pos;
        }
    }

    private void StartTimer()
    {
        timer.gameObject.transform.parent.gameObject.SetActive(true);

        // timer.fillAmount
    }

    private float GetCurrentAngle()
    {
        if (_leftLeg) return currentLeftAngle;
        return currentRightAngle;
    }

    private void FishCaught(Fish fish, Vector3 pos)
    {
        fishList.Remove(fish);
        if (fish.fishGameObject.CompareTag("BlueFish"))
            _blueFishCount++;
        else _redFishCount++;
        availableSlots.Add(pos, fish.angle);
        Destroy(fish.fishGameObject);
        forcePos = true;
        _score++;
        UpdateScore();
        UpdateCount();
    }

    private void UpdateCount()
    {
        var b = _blueFishCount.ToString();
        var r = _redFishCount.ToString();
        if (_blueFishCount < 10)
            b = "0" + b;
        if (_redFishCount < 10)
            r = "0" + r;
        countText.text = "FishCaught\n" + r + "\t\t   " + b + "\n";

        if (_blueFishCount + _redFishCount == _maxScore)
            // StartCoroutine();
            RespawnFish();
        // SceneManager.LoadScene("Scenes/Fishing");
    }

    private void RespawnFish()
    {
        foreach (var fish in fishList)
            if (fish.fishGameObject)
                Destroy(fish.fishGameObject);

        fishList.Clear();
        foreach (var slot in availableSlots)
        {
            var fish = Instantiate(slot.Value < 45 ? fishPrefab : redFishPrefab, slot.Key, Quaternion.identity,
                transform.parent);
            fish.transform.localPosition = slot.Key;
            fishList.Add(new Fish { fishGameObject = fish, angle = slot.Value });
        }

        availableSlots.Clear();
        // _blueFishCount = 0;
        // _redFishCount = 0;
        _maxScore += 4;
        // _score = 0;
        UpdateScore();
        UpdateCount();
    }

    public void ChangeLeg()
    {
        _leftLeg = !_leftLeg;
        SetLegIndicator();
    }

    private void SetLegIndicator()
    {
        if (_leftLeg)
            SceneController.UpdateLeg(SceneController.Leg.Left);
        // buttonImage.sprite = leftLegSprite;
        else
            SceneController.UpdateLeg(SceneController.Leg.Right);
        // buttonImage.sprite = rightLegSprite;
    }

    private IEnumerator CollectData()
    {
        timestamp_time = DateTimeOffset.Now.ToUnixTimeMilliseconds();
        File.AppendAllText(Application.persistentDataPath + $"/fish{timestamp_time}.csv",
            "FishCount,Left,Score,LeftAngle,RightAngle,Time,ALx,ALy,ALz,ARx,ARy,ARz,GLx,GLy,GLz,GRx,GRy,GRz,SessionID\n");
        while (true)
        {
            var fishData = new FishData();
            fishData.FishCount = _blueFishCount + _redFishCount;
            fishData.LeftAngle = currentLeftAngle;
            fishData.RightAngle = currentRightAngle;
            fishData.Time = DateTimeOffset.Now.ToUnixTimeMilliseconds();
            fishData.Left = _leftLeg;
            fishData.Score = _score;
            // fishData.GyroscopeL = currentGyroL;
            // fishData.GyroscopeR = currentGyroR;
            // fishData.AccelerometerL = currentAccL;
            // fishData.AccelerometerR = currentAccR;

            File.AppendAllText(Application.persistentDataPath + $"/fish{timestamp_time}.csv",
                fishData.ToString().Replace("(", "").Replace(")", ""));

            yield return new WaitForSeconds(0);
        }
    }


    [Serializable]
    public struct Fish
    {
        [FormerlySerializedAs("fish")] public GameObject fishGameObject;
        public float angle;
    }

    private struct FishData
    {
        public float FishCount;
        public bool Left;
        public int Score;
        public float LeftAngle;
        public float RightAngle;
        public long Time;

        public Vector3 AccelerometerL;
        public Vector3 AccelerometerR;

        public Vector3 GyroscopeL;
        public Vector3 GyroscopeR;

        // Adjust this as required
        public override string ToString()
        {
            return
                $"fish{FishCount},{(Left ? 1 : 0)},{Score},{LeftAngle},{RightAngle},{Time},{AccelerometerL},{AccelerometerR},{GyroscopeL},{GyroscopeR},{SessionID}\n";
        }
    }
}