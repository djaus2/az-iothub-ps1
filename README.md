## az-iothub-ps

# Azure IoT Hub PowerShell Scripts

_**A PowerShell script that can create an Azure Group, IoT Hub and Device requiring only their names, location and the Hub SKU. It automatically makes all of the Azure queries and posts from that info. The script can be used in a menu manner, or driven in one step from the command line. The script also generates hub connection meta-information and packages it into a ps, sh and json files for transparent use by the Quickstart apps. The repository contains the Quickstart IoT Hub SDK .NET Core apps that have been reworked, extended and added to.**_

**_N.b.: The .NET (Core C#) versions of the Quickstart apps are the focus here._**
<hr>

## Preamble

In the [Azure IoT Hub Quickstarts](https://docs.microsoft.com/en-us/azure/iot-hub/). _take the Quickstart link in the sidebar on left_, a list of steps are repeated on most pages for creating a new Azure IoT Hub from scratch as well as for getting the required Hub connection meta-data. This meta-data is required to be provided as environment variables for the [Quickstart .NET Core Sample apps](https://github.com/Azure-Samples/azure-iot-samples-csharp/archive/master.zip), _(n.b. this is a zip file)_, or provided as command line parameters for the apps. The Quickstart tutorials use the **Azure Cli** (Az Cli) in a **PowerShell** terminal. The UWP app **Azure IoT Hub Toolbox** simplifies this a little, as available as source [GitHub](https://github.com/djaus2/Azure.IoTHub.Toolbox) as well as a ready to run app on the [Microsoft Store](https://www.microsoft.com/en-au/p/azureiothubtoolbox/9pmcf9clttwz?activetab=pivot:overviewtab), with the app's Settings page stepping you through the Hub creation and collection of the meta-data to be used in-app. The Toolbox also requires a PowerShell Az Cli terminal as it supplies the required Az Cli commands on the clipboard.



But wouldn't it be nice to have **ONE PowerShell script that prompts you for required information _(Group, Hub name and Device name)_** when creating or selecting a Hub and for when collecting the required meta-data. Its output could be the required meta-data in temporary environment variables, ready for use by the Quickstarts. _Look no further!_

It's here now.  You run the main PowerShell script **_get-iothub_** in the PS folder. Whilst there are numerous other PowerShell scripts under PS in other folders, these are functions called by the main script. The script displays menus where the user makes selections or choices.

There is one other script that needs to be run once, set-path (run from the prompt in PS foloder as   ```.\set-path``` ). You then can run the main script just by entering ```get-iothub``` as the PS folder is now in the System Path; but only for the life of the  shell. set-path only needs to be run once for a new PowerShell terminal.

- Within an Azure Subscription you have a Resource Group.
- An IoT Hub is an member of a Resource Group.
- A Device belongs to an IoT Hub.
- An IOT Hub and its device both have connection meta-information
- The Quickstart apps(as in this repository) get that info from environment variables, and use it to connect to the hub

<table border="1"  style="background-color:#FFFFE0;"><tr><td>

**A&nbsp;Z&nbsp;U&nbsp;R&nbsp;E&nbsp;&nbsp;I&nbsp;o&nbsp;T&nbsp;&nbsp;H&nbsp;U&nbsp;B&nbsp;&nbsp;S&nbsp;E&nbsp;T&nbsp;U&nbsp;P**&nbsp;&nbsp;_using&nbsp;PowerShell&nbsp;AND&nbsp;Azure&nbsp;CLI_

   Subscription :"Visual Studio Ultimate with MSDN"<br>
          Group :"DSHubGrp"<br>
            Hub :"DSHub" <br>
         Device :"DSHubDevice"<br>

1. **Subscription** <-- _Current Selection_
2. Groups
3. IoT Hubs
4. Devices
5. Generate Environment Variables
6. Quickstart Apps
7. Manage App Data
8. Done

R. Reset script globals<br>
X. Exit<br>
Select action (number). (Default is highlighted) X To exit
</td></tr></table>

_The **get-iothub** PowerShell scipt Main Menu_

<hr>

## Creating an IoT and subservient Device

- Start in PS folder and run ```.\set-path```
- Run ```get-iothub```

- Select the Subscription to use _(Normally only one option here)_
- Create a Group ( or select an existing one)  _(Group option in Main Menu)_
- Create an IoT Hub (or select an existing one) _(Hub option in Main Menu)_
- Create a Device (or select an existing one) _(Device opton in Main Menu)_

- Then Generate Environment Variables (Connection Strings)<br>
  Note only persist for life of existing shell.

### Or the quick way..
- Run ```get-iothub  groupname,hubname,devicename```

You can add a wait period which will skip the default yes confirmations but pause at them for the specified numner of seconds:
- Run ```get-iothub  groupname,hubname,devicename 5```  Thsi will pause for 5 seconds at every [Y] confirmation.

At the start there are 3 menu selections before the script takes off:
- Select Subscription
- Select Location
- Select Hub SKU

## The PS Script CanDos

The script can...
- Create a new Group, IoT Hub and Device
- Generate all of the Hub and Device connection strings required by the IoT Hub SDK for the Quickstart apps and write them as System environment variables and to a PS script to do same.
- Place you in the folder to run a Quickstart (menu of them) with the environment variables set so as to be able to run the app/s.
    - You then just enter ```dontnet run``` to run the app/s.
    - There is also a script in some Quickstart folders to fork two (or 3) processes for when a device and service are required (Eg Device Streaming).
    - The Quickstarts are part of the repository download and have been modified so that you don't need to edit the source to include the connection strings. Connection strings are taken from environment variables. Other mods and extra apps too.
- Install the required version of .NET Core locally (PS/qs-apps/dotnet) and add to path and set required environment variable to it.
   - Can copy qs-apps folder via a share to a remote device. Quickstarts are in ps/qs-apps/quickstarts. Scripts can be placed in quickstarts folder to set environment variables on remote device for connection strings and dotnet.

<hr>

## Quickstart Apps
There is now a device app under Telemetry that uses a DHT22 sensor on a RPi. Only works on Raspian. For further info on that,eg setup, see the repo: https://github.com/djaus2/DNETCoreGPIO  Run the app quickstarts\telemetry\telemetry\simulated-device_on_RPi app from here on the RPi.  Run the mirroring app quickstarts\telemetry\telemetry\read-d2c-messages on the desktop.<br><b>New:</b> control-a-motor variant on control-a-device based upon the motor code in device-streams-cmds-motor. (Only tested on desktop)
<br>
<br>
Also in Device-Streams look in quickstarts\device-streams\device-streams-cmds\device-RPI. The quickstarts\device-streams\device-streams-cmds\service (run on desktop) will now get real live data from this device app when running on the RPi, upon request (send tem or hum). This also uses the DHT22 on the RPi running Raspbian.<br>You can also control a motor remotely using Device Streaming. Look in  quickstarts\device-streams\device-streams-cmds-motor.

See list of Quickstarts below.

<hr>

## The Env Vars scripts

If just running on the desktop then get-iothub can set temporarily set the environment variables for use by the apps on the desktop. If running on the device, you need to set the variables there.

- You can now generate a launchsettings.json file and place it in the Properties folder of an app.<br>
The app will read the variables fromm there at startup.
<p>
Alternatively, the set-env.ps1 and set-env.sh scripts can be copied to the device.

- To set environment variables on the device:
  - In a Window context ```.\set-env```   to run set-env.ps1
  - On Linux (eg Raspian on the Pi)  ```source ./set-env.sh```

<hr>

## The Quickstart Projects and their apps

```
az-iothub-ps\ps\qs-apps
│
├───dotnet
│   You can down a specific SDK or runtimne here for copying to the device.
│
└──Quickstarts
    │
    ├───device-streams
    │   │
    │   ├───device-streams-cmds
    │   │   ├───device
    │   │   ├───device-RPi
    │   │   └───service
    │   │ 
    │   ├───device-streams-cmds-motor
    │   │   ├───device-RPi
    │   │   └───service
    │   │ 
    │   ├───device-streams-echo
    │   │   ├───device
    │   │   └───service
    │   │ 
    │   ├───device-streams-cmds
    │   │   ├───device
    │   │   └───service
    │   │ 
    │   └───device-streams-ucase
    │       ├───device
    │       └───service
    │
    └───telemetry
        ├───control-a-device
        │   ├───back-end-application
        │   └───simulated-device-2
        │
        ├───control-a-motor
        │   ├───back-end-application
        │   ├───read-d2c-messages
        │   └───simulated-device-2
        │
        └───telemetry
            ├───read-d2c-messages
            ├───simulated-device
            └───simulated-device_on_RPi
```
<hr>

Read more on my blog [http://www.sportronics.com.au](http://www.sportronics.com.au/dotnetcoreiot/.NET_Core_on_IoT-Fast_tracking_IoT_Hub_Creation_with_PS-dotnetcoreiot.html)   

Enjoy!
