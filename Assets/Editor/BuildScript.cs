using FlutterUnityIntegration.Editor;
using UnityEditor;
using UnityEngine;
using System.Diagnostics;
using System.IO;

public class BuildScript
{
    public static void PerformBuild()
    {
        // Start the Unity Android library build process
        UnityEngine.Debug.Log("Starting Unity Android library build...");
        Build.DoBuildAndroidLibraryRelease();
        UnityEngine.Debug.Log("Unity Android library build completed.");

        // Set the path to the Flutter project
        string flutterProjectPath = Path.Combine(Application.dataPath, "../.."); // Adjust as needed

        // Run the Flutter build appbundle command
        UnityEngine.Debug.Log("Starting Flutter build appbundle...");
        RunFlutterBuildAppBundle(flutterProjectPath);
        UnityEngine.Debug.Log("Flutter build appbundle completed.");
    }

    private static void RunFlutterBuildAppBundle(string flutterProjectPath)
    {
        Process process = new Process();

        // Configure the process to run the Flutter command
        process.StartInfo.FileName = "flutter";
        process.StartInfo.Arguments = "build appbundle";
        process.StartInfo.WorkingDirectory = flutterProjectPath;
        process.StartInfo.UseShellExecute = false;
        process.StartInfo.RedirectStandardOutput = true;
        process.StartInfo.RedirectStandardError = true;

        // Attach event handlers to capture output and errors
        process.OutputDataReceived += (sender, args) => UnityEngine.Debug.Log(args.Data);
        process.ErrorDataReceived += (sender, args) => UnityEngine.Debug.LogError(args.Data);

        try
        {
            process.Start();
            process.BeginOutputReadLine();
            process.BeginErrorReadLine();
            process.WaitForExit();

            if (process.ExitCode != 0)
            {
                UnityEngine.Debug.LogError($"Flutter build appbundle failed with exit code {process.ExitCode}");
            }
        }
        catch (System.Exception ex)
        {
            UnityEngine.Debug.LogError($"Failed to run Flutter build appbundle: {ex.Message}");
        }
        finally
        {
            process.Close();
        }
    }
}
