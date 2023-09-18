
cd ..\..\

if "%1%"=="clean" (
   echo Running clean...
   flutter clean
) else (
   echo Skipping clean...
)

if "%1%"=="get" (
    echo Running pub get...
    flutter pub get
) else (
    echo Skipping get...
)

if "%1%"=="apk" (
   echo Building APK...
   flutter build apk --release
) else (
   echo Building AAB...
   flutter build appbundle --release
)