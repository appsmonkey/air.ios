//
//  Text.swift
//  CityOSAir
//
//  Created by Andrej Saric on 28/08/16.
//  Copyright © 2016 CityOS. All rights reserved.
//

import Foundation

// TOD: regactor all to localizable strings
struct Text {

  struct Menu {
    static let sarajevoCityAir = "Sarajevo Air"
    static let belgradeCityAir = "Belgrade Air"
    static let cityMap = "Air Map"
    static let logIn = "Log into device"
    static let aqiPM10 = "PM₁₀ Index"
    static let aqiPM25 = "PM2.5 Index"
    static let settings = "Settings"
    static let deviceRefresh = "Refresh Devices"
  }

  struct Buttons {
    static let loginBtn = "Log In"
    static let continueBtn = "Continue"
    static let noDeviceBtn = "I don't have a device"
  }

  struct Placeholders {
    static let email = "Email"
    static let password = "Password"
    static let firstName = "First Name"
    static let lastName = "Last Name"
    static let verifyPassword = "Verify Password"
    static let confirmPassword = "Confirm password"
    static let wifiPassword = "WiFi Password"
    static let birthday = "Birthday"
  }

  struct CreateIntro {

    static let topText = "The Clean Air\n Movement Starts Here"

    struct Buttons {
      static let start = "Get Started"
    }
  }

  struct ConnectIntro {

    static let topText = "Connect to Air"

    static let contentText = "Press and hold the gold\n button below until a blue light\n starts blinking."

    struct Buttons {
      static let logout = "Logout"
    }

    struct Messages {
      static let alertMsg = "Couldn't find device. Make sure the battery is charged."
      static let alertBtn = "OK"
      static let loadingMsg = "Processing..."
    }
  }

  struct ConnectWiFI {
    static let title = "Connect to WiFi"

    struct Messages {
      static let connecting = "Connecting to WiFI..."
      static let connected = "Connected to "
    }
  }

  struct MyDevice {

    static let title = "My Device"

    static let wifi = "Wifi Settings"

    static let forget = "Forget Device"

    static let logout = "Logout"

  }

  struct AccountCreate {

    static let title = "Create Account"

    struct Buttons {
      static let existingAccBtn = "Log into existing account"
      static let signupBtn = "Sign Up"
    }

    struct Messages {
      static let emailError = "Please enter a valid email address"
      static let passwordError = "Passwords don't match"
      static let loadingMsg = "Creating account..."

    }
  }

  struct LogIn {

    static let title = "Log Into Device"

    struct Buttons {
      static let forgotPassword = "Forgot Password?"
      static let logIn = "Log In"
      static let signUpWithEmail = "Sign up with email"
      static let viewSarajevoAir = "View Sarajevo Air"
    }

    struct Messages {
      static let loadingMsg = "Logging in..."
    }
  }

  struct ResetPassword {

    static let title = "Reset Password"

    struct Messages {
      static let alertMsg = "We emailed you a link to reset your password."
      static let alertBtn = "Go to Login"
    }

    struct Button {
      static let continueTitle = "Continue"

    }
  }

  struct Readings {
    static let title = "Sarajevo Air"
    static let subtitle = "Changed "
  }

  struct Settings {
    static let title = "Settings"
    static let logout = "Logout"
    static let login = "Log into device"
    static let notificationsTitle = "Notifications"
    static let notificationsDetail = "Receive bad air alerts"
    static let notificationsOn = "On"
    static let notificationsOff = "Off"
    static let notifyMe = "Notify me when air is:"

    struct AirAlerts {
      static let title = "Air Alerts"
      static let good = "Good"
      static let moderate = "Moderate"
      static let sensitive = "Unhealthy for sensitive"
      static let unhealthy = "Unhealthy"
      static let veryUnhealthy = "Very Unhealthy"
      static let hazardous = "Hazardous"
      static let footer = "Alerts are sent per pollution level."
    }
  }

  struct PM10 {
    static let title = "PM₁₀ Index"
    static let subtitle = "These are the PM₁₀ index values based on USA EPA\n and are based on a 24-hour average."
  }

  struct PM25 {
    static let title = "PM2.5 Index"
    static let subtitle = "These are the PM2.5 index values based on USA EPA\n and are based on a 24-hour average."
  }

  struct Ribbons {
    static let great = "GREAT"
    static let ok = "OK"
    static let sensitive = "SENSITIVE BEWARE"
    static let unhealthy = "UNHEALTHY"
    static let veryUnhealthy = "VERY UNHEALTHY"
    static let hazardous = "HAZARDOUS"
  }
}


