using FlutterUnityIntegration.Editor;
using UnityEditor;
using UnityEngine;
using System.Diagnostics;

public class BuildScript
{
    public static void PerformBuild()
    {
        // Start the Unity Android library build process
        Build.DoBuildAndroidLibraryRelease();
    }
}