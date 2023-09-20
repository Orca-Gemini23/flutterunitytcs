
cd ..\..\

if "%1%"=="clean" (
   echo Running clean...
   C:/flutter/bin/flutter clean
) else (
   echo Skipping clean...
)

if "%1%"=="get" (
    echo Running pub get...
    C:/flutter/bin/flutter pub get
) else (
    echo Skipping get...
)

if "%1%"=="apk" (
   echo Building APK...
   C:/flutter/bin/flutter build apk --release --verbose
) else (
   echo Building AAB...
   C:/flutter/bin/flutter build appbundle --release --verbose
)