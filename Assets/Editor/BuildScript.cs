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

        // Run Flutter build appbundle
        RunFlutterBuildAppBundle();
    }

    private static void RunFlutterBuildAppBundle()
    {
        Process process = new Process();
        process.StartInfo.FileName = "flutter";
        process.StartInfo.Arguments = "build appbundle";
        process.StartInfo.UseShellExecute = false;
        process.StartInfo.RedirectStandardOutput = true;
        process.StartInfo.RedirectStandardError = true;
    }
}