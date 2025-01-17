using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Obstacle : MonoBehaviour
{
    private TaxiGame taxiGame;
    private void Start()
    {
        taxiGame= FindObjectOfType<TaxiGame>();
    }


    // Update is called once per frame
    void Update()
    {
        var speed = taxiGame.movementSpeed;
        transform.position += Vector3.down* (Time.deltaTime * speed);
        
    }

    private void OnCollisionEnter2D(Collision2D other)
    {
        Debug.Log("Collided");
        if (other.gameObject.CompareTag("Finish"))
        {
            Destroy(gameObject);
            Debug.Log("Obstacle Destroyed");
        }
    }

    private void OnTriggerEnter2D(Collider2D other)
    {
        Debug.Log("Triggered");
        if (other.gameObject.CompareTag("Finish"))
        {
            Destroy(gameObject);
            Debug.Log("Obstacle Destroyed");
        }
    }
}
