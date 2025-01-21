using System.Diagnostics; // For running shell commands
using UnityEditor; // For Unity build integration
using UnityEngine; // For logging

public static class BuildScript
{
    public static void PerformBuild()
    {
        // Run Flutter build bundle
        ExecuteFlutterCommand("build bundle");

        // Run Flutter build APK
        ExecuteFlutterCommand("build apk --release");
    }

    private static void ExecuteFlutterCommand(string arguments)
    {
        ProcessStartInfo processStartInfo = new ProcessStartInfo
        {
            FileName = "flutter", // Ensure Flutter is in PATH or provide full path
            Arguments = arguments,
            RedirectStandardOutput = true,
            RedirectStandardError = true,
            UseShellExecute = false,
            CreateNoWindow = true
        };

        using (Process process = new Process())
        {
            process.StartInfo = processStartInfo;
            process.Start();

            // Capture output and errors
            string output = process.StandardOutput.ReadToEnd();
            string error = process.StandardError.ReadToEnd();

            process.WaitForExit();
        }
    }
}