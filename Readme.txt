name = Walk
appId = com.lifesparktech.walk
Hello dev 
This is the official documentation of the Walk application .
Starting off with the dependencies and assets all of the assets are inside assets/folder and also mentioned in the pubspec.yaml.

Folder Structure :
    lib folder is the root folder containes all the folders needed and necessary for the working of walk.
    env : This folder contains a single flavors.dart file which is used to define in which dev mode currently the application is in .
    src : 
        constans : This folder contains all of the constants used by darts separated in different files.
        controllers : These are the providers used by the walk application (We follow an MVC pattern)
        db : This folder contains the configuration of the local database to store user data 
        models : This folder contains dart models of the Classes used by Walk for example ChartDetails etc.
        utils : This is basically all the collections of common files and functions used by Walk app , 
        views : As defined previously this contains the UI of different screens used in the project
        widgets : widgets are smaller components used by the project , ex : dialog box , progress bar , buttons etc .
    
    backgroundservice.dart : This file contains functions and initialization of the backgroundservice used by project .
    main.dart : This is the main file or the entry point of the project 
    walk_app.dart : This is the root element of our Project consider this as the MyApp() 

Pipeline Details :
    .gitlab-ci.yml : This is the main file where stages are defined for the pipeline.

android/fastlane : This is the fastlane