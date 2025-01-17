using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using TMPro;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.Serialization;
using UnityEngine.UI;
using Random = UnityEngine.Random;

public class TaxiGame : GameMode
{
    // Start is called before the first frame update
    [SerializeField] private GameObject player;
    
    [SerializeField] Transform[] SpawnPoints;
    [SerializeField] GameObject[] Obstacles;
    [SerializeField] GameObject pauseMenu;

    [SerializeField] private GameObject debugButton;
    float timeSinceLastSpawn;
    [FormerlySerializedAs("spawnRate")] public float spawnInterval = 2.5f;
    public float movementSpeed = 20f;
    
    List<GameObject> activeObstacles= new();
    
    public Slider spawnRateSlider;
    public Slider movementSpeedSlider;
    
    
    
    new void Start()
    {
        base.Start();
        if(PlayerPrefs.HasKey("spawnRate"));
        { 
            SetSpawnRate(PlayerPrefs.GetFloat("spawnRate"));
            spawnRateSlider.value = PlayerPrefs.GetFloat("spawnRate");
        }
        if(PlayerPrefs.HasKey("movementSpeed"));
        {
            SetMovementSpeed(PlayerPrefs.GetFloat("movementSpeed"));
            movementSpeedSlider.value = PlayerPrefs.GetFloat("movementSpeed");
        }
        Spawn();

    }
    public float calculate_pitch(float x, float y, float z)
    {
        float pitchRadians = Mathf.Atan(x / (Mathf.Sqrt(y * y) + (z * z)));
        float pitchDegrees = pitchRadians * (180.0f / Mathf.PI);

        return pitchDegrees;
    }
    public float calculate_roll(float x, float y, float z) {
        float rollRadians = Mathf.Atan(y / Mathf.Sqrt((x*x) + (z*z)));
        float rollDegrees = rollRadians * (180.0f / Mathf.PI);

        if(z > 0.0)
        {
            rollDegrees = Mathf.Abs(rollDegrees);
        } else
        {
            rollDegrees = 180.0f - Mathf.Abs(rollDegrees);
        }

        return rollDegrees;
    }


    new void Update()
    {
        base.Update();
        
        var currentLeftAngle = calculate_pitch(InputController.CurrentLeftAcc.x,InputController.CurrentLeftAcc.y,InputController.CurrentLeftAcc.z);
        var currentRightAngle = calculate_pitch(InputController.CurrentRightAcc.x, InputController.CurrentRightAcc.y,
            InputController.CurrentRightAcc.z);
        
        currentLeftAngle = Mathf.Clamp(currentLeftAngle, 0, 90);
        currentRightAngle = Mathf.Clamp(currentRightAngle, 0, 90);
        
        debugButton.GetComponentInChildren<TextMeshProUGUI>().text=currentLeftAngle.ToString()+" "+currentRightAngle.ToString();
        
        player.transform.position += Vector3.left * (Time.deltaTime * currentLeftAngle);
        player.transform.position += Vector3.right * (Time.deltaTime* currentRightAngle);

        var vector3 = player.transform.localPosition;
        vector3.x = Mathf.Clamp(player.transform.localPosition.x, -125f, 125f);
        player.transform.localPosition = vector3;
        
        timeSinceLastSpawn += Time.deltaTime;
        if (timeSinceLastSpawn > spawnInterval)
        {
            Spawn();
        }
    }



    int[] laneWeights = { 1, 1, 1 };

    private void Spawn()
    {
        int totalWeight = laneWeights.Sum(); // Calculate total weight
        int randomWeight = Random.Range(0, totalWeight);

        int lane = 0;
        for (int i = 0; i < laneWeights.Length; i++)
        {
            randomWeight -= laneWeights[i];
            if (randomWeight < 0)
            {
                lane = i;
                break;
            }
        }
        // Adjust weights to favor other lanes next time
        for (int i = 0; i < laneWeights.Length; i++)
            laneWeights[i] = i == lane ? 1 : laneWeights[i] + 1;
        timeSinceLastSpawn = 0;
        // int spawnPointIndex = Random.Range(0, SpawnPoints.Length);
        int obstacleIndex = 0;
        var instantiate = Instantiate(Obstacles[obstacleIndex], SpawnPoints[lane].transform);
        instantiate.SetActive(true);
        activeObstacles.Add(instantiate);
    }

    public void Pause ()
    {
        Time.timeScale = 0;
        pauseMenu.SetActive(true);
    }
    public void UnPause ()
    {
        Time.timeScale = 1;
        pauseMenu.SetActive(false);
    }
    public void SetSpawnRate(float rate)
    {
        if (rate <= 0.1f)
        {
            rate = 0.1f;
        }
        print(rate);
        spawnInterval = 2 / rate;
        PlayerPrefs.SetFloat("spawnRate", rate);
    }
    public void SetMovementSpeed(float speed)
    {
        movementSpeed = 40*speed;
        PlayerPrefs.SetFloat("movementSpeed", speed);
    }

    protected override void LogData()
    {
    }
}