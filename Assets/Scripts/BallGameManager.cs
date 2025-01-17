using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using FlutterUnityIntegration;
using UnityEngine;
using UnityEngine.Serialization;
using Random = UnityEngine.Random;

public class BallGameManager : GameMode
{
    [FormerlySerializedAs("left")] public GameObject leftLeg;
    [FormerlySerializedAs("right")] public GameObject rightLeg;
    [SerializeField] private GameObject ball;

    [FormerlySerializedAs("BallSpawnPoints")] [SerializeField]
    private List<Transform> ballSpawnPoints;

    [SerializeField] private float _speed;
    private Ball _ball;
    private int _direction;

    private BoxCollider2D _leftBoxCollider2D;


    private float _leftInitialY;
    private BoxCollider2D _rightBoxCollider2D;
    private float _rightInitialY;
    private float _speedMultiplier = 1;


    private new void Start()
    {
        base.Start();

        _ball = ball.GetComponent<Ball>();
        Ball.CollisionEvent.AddListener(HandleCollision);
        _leftBoxCollider2D = leftLeg.gameObject.GetComponent<BoxCollider2D>();
        _rightBoxCollider2D = rightLeg.gameObject.GetComponent<BoxCollider2D>();

        _leftInitialY = leftLeg.transform.localPosition.y;
        _rightInitialY = rightLeg.transform.localPosition.y;


        StartCoroutine(SpawnBall());
        File.AppendAllText(Application.persistentDataPath + $"/ball{SessionID}.csv",
            "Bx,By,Bz,Left,Score,LeftAngle,RightAngle,Time,LastLeftBeep,LastRightBeep,AccelerometerLx,AccelerometerLy,AccelerometerLz,AccelerometerRx,AccelerometerRy,AccelerometerRz,GyroscopeLx,GyroscopeLy,GyroscopeLz,GyroscopeRx,GyroscopeRy,GyroscopeRz,SessionID\n");
    }


    private new void Update()
    {
        base.Update();


        ball.transform.position += Vector3.down * (Time.deltaTime * _direction * _speedMultiplier * _speed);

        currentLeftAngle = Mathf.Clamp(currentLeftAngle, 0, 90);
        currentRightAngle = Mathf.Clamp(currentRightAngle, 0, 90);

        _leftBoxCollider2D.enabled = currentLeftAngle >= 30;
        _rightBoxCollider2D.enabled = currentRightAngle >= 30;


        leftLeg.transform.localPosition = new Vector3(leftLeg.transform.localPosition.x,
            _leftInitialY + currentLeftAngle * Mathf.Deg2Rad * 200, leftLeg.transform.localPosition.z);
        rightLeg.transform.localPosition = new Vector3(rightLeg.transform.localPosition.x,
            _rightInitialY + currentRightAngle * Mathf.Deg2Rad * 200, rightLeg.transform.localPosition.z);
    }

    private void HandleCollision(Collider2D other)
    {
        if (_direction == 1)
        {
            if (other.CompareTag("Vibration"))
            {
                Vibrate();
            }
            else
            {
                IncrementScore();
                UnityMessageManager.Instance.SendMessageToFlutter("xc" + score + "c" + Time.timeSinceLevelLoad);

                _direction = -1;
            }
        }
    }

    private IEnumerator SpawnBall()
    {
        while (true)
        {
            if (activeLeg == ActiveLeg.Left)
                activeLeg = Random.Range(0, 2) == 0 ? ActiveLeg.Left : ActiveLeg.Right;
            else
                activeLeg = Random.Range(0, 2) == 0 ? ActiveLeg.Right : ActiveLeg.Left;


            ball.transform.position = ballSpawnPoints[(int)activeLeg].position;
            _direction = 1;
            yield return new WaitUntil(BallIsOutOfBounds);
            // yield return new WaitForSeconds(5);
        }
    }

    private bool BallIsOutOfBounds()
    {
        return ball.transform.position.y > ballSpawnPoints[0].position.y + 1 || ball.transform.position.y < 0;
    }


    protected override void LogData()
    {
        var ballData = new BallData
        {
            LeftAngle = currentLeftAngle,
            RightAngle = currentRightAngle,

            BallPos = _ball.transform.position,
            Score = score,

            Left = activeLeg == ActiveLeg.Left ? 1 : 0,
            Time = DateTimeOffset.Now.ToUnixTimeMilliseconds(),

            LastLeftBeep = lastLeftBeep,
            LastRightBeep = lastRightBeep,

            AccL = InputController.CurrentLeftAcc,
            AccR = InputController.CurrentRightAcc,

            GyroL = InputController.CurrentLeftGyro,
            GyroR = InputController.CurrentRightGyro
        };
        File.AppendAllText(Application.persistentDataPath + $"/ball{SessionID}.csv",
            ballData.ToString().Replace("(", "").Replace(")", ""));
    }

    public void SetSpeed(float speed)
    {
        _speedMultiplier = speed + 1;
    }


    private class BallData : GameData
    {
        public Vector3 BallPos;

        public override string ToString()
        {
            return
                $"{BallPos},{Left},{Score},{LeftAngle},{RightAngle},{Time},{LastLeftBeep},{LastRightBeep},{AccL},{AccR},{GyroL},{GyroR},{SessionID}\n";
        }
    }
}