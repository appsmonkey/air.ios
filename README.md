<p align="center"><a href="https://apps.apple.com/us/app/cityos-air/id1149070470"><img src="images/cityos-air.png" /></a></p>
<p align="center"><a href="https://apps.apple.com/us/app/cityos-air/id1149070470"><img src="images/app-store-badge.png" width="250" /></a></p>

<p align="center">
    <a href="https://testflight.apple.com/join/h9XbgsGF">
      <img src="https://img.shields.io/badge/Join-TestFlight-blue.svg"
           alt="Join TestFlight" />
    </a>
</p>

![Platforms: iOS](https://img.shields.io/badge/Platform-iOS-lightgrey)
![Language: Swift](https://img.shields.io/badge/language-swift-orange.svg)
![Version: v2.5](https://img.shields.io/badge/version-v2.5-lightgrey)

CityOS Air is the highest rated enironmental app in the South European region.

|         | Features  |
----------|-----------------
:thumbsup: | The power of clean air is right at your fingertips with the air app
:thumbsup: | Monitor all sensors in real time for a comprehensive picture of the air quality and the environment
:thumbsup: | Automatic syncing to the cloud, your air data goes with you no matter where you are.
:thumbsup: | The app provides you with comprehensive data and graph trends to give you a deeper understanding of your surroundings, air pollution patterns, and insights into the source of poor air quality as it happens.
:octocat: | 100% free and open source

## Contributing

We are always looking for contributions from **all skill levels**! A great way to get started is by helping [organize and/or squish bugs](https://github.com/appsmonkey/air.ios/issues?q=is%3Aopen+is%3Aissue+label%3Abug). If you're looking to ease your way into the project try out a [good first issue](https://github.com/appsmonkey/air.ios/issues/17).

### Screenshots

<table align="center" border="0">

<tr>
<td> <img src="images/cityos-air1.png"> </td>
<td> <img src="images/cityos-air2.png"> </td>
<td> <img src="images/cityos-air3.png"> </td>
</tr>

<tr>
<td> <img src="images/cityos-air4.png"> </td>
<td> <img src="images/cityos-air5.png"> </td>
<td> <img src="images/cityos-air6.png"> </td>
</tr>

</table>


## Installation

[Download](https://developer.apple.com/downloads/index.action) and install Xcode. *CityOS Air for iOS* requires Xcode 11.2.1 or newer.

#### CocoaPods

CityOS Air for iOS uses [CocoaPods](http://cocoapods.org/) to manage third party libraries. To get started, you will need to install cocoapods (`sudo gem install cocoapods`), then run these instructions:

```sh
git clone git@github.com:appsmonkey/air.ios.git
cd air.ios/CityOSAir/
pod install
open CityOSAir.xcworkspace/
```

NOTE: to install cocoapods you will need to install Ruby. The best place for MacOS is [GoRails](https://gorails.com/setup/osx/)

## Dependencies
For handling Network requests, we used famouse [Alamofire](https://github.com/Alamofire/Alamofire).</br>
...

Pods included in project:

```
pod 'Charts'
pod 'RealmSwift'
pod 'Fabric'
pod 'Crashlytics'
pod 'Firebase/Messaging'
pod 'Firebase/Analytics'
pod 'Firebase/Auth'
pod 'GoogleMaps'
pod 'Alamofire'
pod 'ReachabilitySwift'
pod 'UrbanAirship-iOS-SDK'
pod 'SnapKit'
pod 'GoogleSignIn'
pod 'FacebookSDK'
pod 'FacebookSDK/LoginKit'
pod 'SwiftyBeaver'
pod 'KeychainAccess'
pod 'SVProgressHUD'
pod 'Cluster'

```

### Open Xcode

Launch the workspace by running the following from the command line:

`open CityOSAir.xcworkspace`

You can also open the project by double clicking on `CityOSAir.xcworkspace` file, or launching Xcode and choose `File` > `Open` and browse to `CityOSAir.xcworkspace`.

Open it then hit <kbd>command</kbd> + <kbd>R</kbd>, Done!

### Running the app for the first time and onboarding

The first time you will be presented with welcome screen.

<p align="center"><img src="images/welcome.png" width="300" /></p>

Click **Login Into Device** and you will be presented with the login screen. Here we start with the onboarding process by either logging in with one of social accounts, which is quick and easy, or by registering with an email address and password, which require email confirmation. This process is augmented with **deep links** to ease the onboarding process. Because the *Social Login* registration is very easy we will describe here only the email/password onbarding. Click on the **Sign up with email** button on the *Login Screen* and you will be presented with the first step in creating an account. On this screen type in the email you want to use and click continue. It must not be already registered or used with either of the social logins. If the email is validated the first step is done and you will be presented with the screen which will inform you that your are to receive an email to the email address used.

<table align="center" border="0">

<tr>
<td> <img src="images/registration1.png"> </td>
<td> <img src="images/registration2.png"> </td>
<td> <img src="images/registration3.png"> </td>
</tr>

</table>

If you are using gmail account the best is to open gmail in Safari or to copy the link from gmail app to iOS Notes app for **deep links** to work properly and open the app on the last screen in the registration process.

<p align="center"><img src="images/registration4.jpeg" width="300" /></p>

Click on **Verify email** or on link if the former does not open CityOS Air app and you should be presented with the following screen.

<p align="center"><img src="images/registration5.jpeg" width="300" /></p>

Enter the data, click **Create Account**, and if all is validated the app will take you to login screen and automatically login. You can opt to save password for the screen if offered by iOS.

<p align="center"><img src="images/home-city.jpeg" width="300" /></p>

Click on the top right icon/button and you will be transfered to the City Map. On the map you can see devices and by clicking on any of them an info window will slide in on the bottom to show PM10 and PM2.5 data as well as temperature, if there are data data readings. Otherwise the info will say either no data or device offline. By clicking on the info window you will be transfered to the device's dashboard. It is good to know that via side menu we can access only our devices, mine switch on map, for the rest of the devices, devices that belong to someone else, to access their dashboard map is the way to go.

<table align="center" border="0">

<tr>
<td> <img src="images/map1.png"> </td>
<td> <img src="images/map2.png"> </td>
<td> <img src="images/map3.png"> </td>
</tr>

</table>

## Add Device

Now is the time to add our own device. Bellow is the ordered flow and underneath some clarifications and instructions. Open side menu and click on *Add Device*. You will be presented with the Connect Device screen.

<table align="center" border="0">

<tr>
<td> <img src="images/adddevice-ios1.png"> </td>
<td> <img src="images/adddevice-ios2.png"> </td>
<td> <img src="images/adddevice-ios3.png"> </td>
</tr>

<tr>
<td> <img src="images/adddevice-ios4.png"> </td>
<td> <img src="images/adddevice-ios5.png"> </td>
<td> <img src="images/adddevice-ios6.png"> </td>
</tr>

</table>

Click on the **Open Settings** button and you will be transfered to the iOS settings. Naviate to the WiFi portion and select your device whose SSID should start with Boxy-{code}. Once connected go back to CityOS Air and click on the **Configure Device** button. On the **Configure Device** screen select your internet WiFi SSID and the SSID field should be automatically filled in. Enter the password carefully, because if the wrong password is entered Boxy will not be able to access the internet, and thus to send the data. You will need to re-add it again in that case. Once you entered the password click **Save** and you should be transfered to the **Device Location** screen. Since your iPhone was connected to the Boxy's SSID, it might take a few moments for connection to reset to your WiFi. When that is done map will show on the screen. Select location of your BoxY and click **Continue**. On the next, **Device Info** screen, enter the device's name and switch on **Indoor** if the device is an indoor device. Click **Done** and you will be transfered to the device's dahsboard screen. Congratulations, you have your first Boxy set up feeding you data about how healthy is the air you breathe, in house, or oudtoors, which is important thing to know, and you can do it now in a way previously available only to big institutions for a lot of money. 

## Resources

- The [docs](docs/) contain information about our development practices.

## Open Source & Copying

We ship CityOS Air on the App Store for free and provide its entire source code for free as well.

However, **please do not ship this app** under your own account?

## Why are we building this?

We are group of people who care about the envirnment and the better future of humanity.

## Code of Conduct

We aim to share our knowledge and findings as we work daily to improve our
product, for our community, in a safe and open space. We work as we live, as
kind and considerate human beings who learn and grow from giving and receiving
positive, constructive feedback.