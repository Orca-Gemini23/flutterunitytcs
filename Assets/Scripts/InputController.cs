using System.Collections.Generic;
using System.Linq;
using UnityEngine;

public class InputController : MonoBehaviour
{
    public static float CurrentLeftAngle;
    public static float CurrentRightAngle;
    public static Vector3 CurrentLeftAcc;
    public static Vector3 CurrentRightAcc;
    public static Vector3 CurrentLeftGyro;
    public static Vector3 CurrentRightGyro;

    private readonly Queue<Quaternion> _leftQuatQueue = new();

    private string[] _angles = new string[2];
    private Vector3 _initialAccL;
    private Vector3 _initialAccR;
    private Vector3 _initialGyroL;
    private Vector3 _initialGyroR;
    private Queue<Vector3> _leftQueue = new();
    private float _previousLeftTime;
    private float _previousRightTime;
    private Queue<Vector3> _rightQueue = new();
    private float _tempAngle;
    private Vector3 quatAngles;


    // Start is called before the first frame update
    public static InputController Instance { get; private set; }

    private void Awake()
    {
        if (Instance != null && Instance != this)
            Destroy(this);
        else
            Instance = this;
    }

    // private void OnGUI()
    // {
    //     var style = new GUIStyle();
    //     style.fontSize = 25;
    //     style.normal.textColor = Color.red;
    //     // GUI.Label(new Rect(10, 50, 100, 200), "Left Angle: " + CurrentLeftAngle, style);
    //     GUI.Label(new Rect(10, 50, 100, 200), "Right Angle: " + _tempAngle, style);
    // }

    public void SetAccelerometerValue(string message)
    {
        var parts = message.Split(" ");
        if (message.Length < 15)
        {
            SetCurrentAngle($"{parts[1]},{parts[3]}");
        }
        else
        {
            var acc = new Vector3(float.Parse(parts[2]), float.Parse(parts[3]), float.Parse(parts[4]));
            var gyro = new Vector3(float.Parse(parts[5]), float.Parse(parts[6]), float.Parse(parts[7]));
            //[L : 1.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            if (parts[0] == "R")
            {
                CurrentRightAcc = acc;
                CurrentRightGyro = gyro;
                SetImu(acc, gyro, ref _previousRightTime, ref _initialAccR, ref _initialGyroR, ref CurrentRightAngle,
                    -1, ref _rightQueue);
            }
            else if (parts[0] == "L")
            {
                CurrentLeftAcc = acc;
                CurrentLeftGyro = gyro;
                SetImu(acc, gyro, ref _previousLeftTime, ref _initialAccL, ref _initialGyroL, ref CurrentLeftAngle, 1,
                    ref _leftQueue);
            }
        }
    }

    private void SetCurrentAngle(string message)
    {
        _angles = message.Split(",");
        CurrentLeftAngle = float.Parse(_angles[0]);
        CurrentRightAngle = float.Parse(_angles[1]);
    }

    private void SetImu(Vector3 acc, Vector3 gyro, ref float previousTime, ref Vector3 initialAcc,
        ref Vector3 initialGyro, ref float currentAngle, int multFactor, ref Queue<Vector3> queue)
    {
        if (previousTime == 0)
        {
            previousTime = Time.time;
            initialAcc = acc;
            initialGyro = gyro;
        }

        // CalculateAngleViaQuaternion(initialAcc, acc, ref currentAngle);

        queue.Enqueue(acc);
        if (queue.Count >= 10)
        {
            queue.Dequeue();
            var accValues = queue.ToArray();
            acc.x = accValues.Average(
                v => v.x);
            acc.y = accValues.Average(
                v => v.y);
            acc.z = accValues.Average(v => v.z);
        }

        previousTime = Time.time;
        CalculateAngle(initialAcc, acc * multFactor, ref currentAngle);
    }


    private void CalculateAngle(Vector3 initialAcc, Vector3 acc, ref float angle)
    {
        var quat = Quaternion.FromToRotation(initialAcc, acc);

        var tempAngle = Quaternion.Lerp(Quaternion.Euler(0, 0, 0), quat, 1f).eulerAngles.z;

        if (angle.Equals(CurrentLeftAngle))
        {
            if (tempAngle > 180)
                tempAngle = 360 - tempAngle;
            else
                tempAngle = -tempAngle;
        }
        else
        {
            tempAngle = tempAngle - 180;
        }

        angle = Mathf.Clamp(tempAngle, -90, 90);
    }
}