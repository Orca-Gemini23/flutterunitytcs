using Editor;
using UnityEditor;
using UnityEngine;

public class BuildScript
{
    public static void PerformBuild()
    {
        // Start the build proces
        Build.DoBuildAndroidLibraryRelease();
    }
}
