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
        Process process = new Process();
        process.StartInfo.FileName = "cmd.exe"; // Use the command line
        process.StartInfo.Arguments = "/c flutter build appbundle"; // Command to run
        process.StartInfo.UseShellExecute = false;
        process.StartInfo.RedirectStandardOutput = true;
        process.StartInfo.RedirectStandardError = true;

        process.OutputDataReceived += (sender, args) => UnityEngine.Debug.Log(args.Data); // Explicitly UnityEngine.Debug
        process.ErrorDataReceived += (sender, args) => UnityEngine.Debug.LogError(args.Data); // Explicitly UnityEngine.Debug

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
            UnityEngine.Debug.LogError($"Error running Flutter build appbundle: {ex.Message}");
        }
        finally
        {
            process.Close();
        }
    }
}g