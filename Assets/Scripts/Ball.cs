using TMPro;
using UnityEngine;
using UnityEngine.Events;

public class Ball : MonoBehaviour
{
    public static readonly UnityEvent<Collider2D> CollisionEvent = new();
    public TextMeshProUGUI score;

    private void OnTriggerEnter2D(Collider2D other)
    {
        CollisionEvent.Invoke(other);
    }
}