
# WALK

Support application for the mobility aid WALK .




## Features

- Ble Communication with the  health band
- Statistics using flutter charts
- AR therapy mode with Rive Animations
- Implementation of Native features


## Folder Structure
The application follows a loose mvc pattern and the folders are structured in the same way.

There are three main folders named as screens , controllers and models

#### Screens (views):
Screens are ui components of the application which are responsible for the UI and presentation of the same.The components of a ui are also seggregated or broken into several smaller components so that the components can be reused. 


#### Controllers :
Controllers are basically the main components where the business logic is implemented.Controllers handle the change in the app data and also are responsible of providing the updated data to the application . Most of the controllers are ChangeNotifiers the call notifyListeners() when ever a value is changed and need to be updated in the UI also.


#### Models :
Models are classes that represent a particular object and its properties.
There are multiple models such as user model , game model etc. These models contains the fields and properties of an object . Further these models also contain the method to convert the user json data to a model object.


## Application Flow 

The image below presents the flow of the application.

![Application Flow](https://drive.google.com/uc?export=view&id=1E7pmMyjAGDU8umeYqnttBTJC8fpxj-xe)
## Main Libraries 
This application uses multiple packages , some of which are very crucial and are adviced not to be replaced or changed.Some of those packages are 

flutter_blue_plus => This library is the heart of the bluetooth communication for the project , 
multiple packages offering ble capabilities were tried before actually settling for this one .
Also one of the major reasons this library was choosen is the capability of ble operations with foreground services.

flutter_background_service => This is the core library used for foreground services in the application , many other packages were tried but this one fits best . A Disadvantage being that , Awesome Notifications plugin does not work with foreground or background service. 

provider => This library also plays a major role in managing the state of the application , though this can be replaced with a bloc , if in future the application's size increases switching to bloc may prove effective.

## CI/CD
This application is also equipped with CI/CD script . CI/CD script is run with gitlab runners , which are nothing but services that run in the local system (usually in the ones where development happens).The builds and deployement are handled by this script only along with [Fastlane](https://fastlane.tools/)
The configuration and the stages are defined in the .gitlab-ci.yml .
Stages are similar to function that have multiple steps defined for that .For more detailed description on Gitlab CICD [Link to Document](https://docs.gitlab.com/runner/). 