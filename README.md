# Azure IoT Hub PowerShell Scripts V3.0.4

_**az-iothub-ps is a PowerShell script that can create an Azure Group, IoT Hub, Device and Device Provisioning Service (DPS) requiring only their names, location and the Hub SKU. It automatically makes all of the Azure queries and posts from that info. The script can be used in a menu manner, or driven in one step from the command line. The script also generates Hub connection meta-information and packages it into a ps, sh and json files for transparent use by the Azure IoT Hub SDK Quickstart apps. The repository contains those Quickstart IoT Hub SDK .NET Core apps that have been reworked, extended and added to. Also, there is now has support for DPS and Azure Sphere, including the AzSphere command prompt as a PowerShell.**_

**_N.b.: The .NET (Core C#) versions of the Azure IoT SDK Quickstart apps are the focus here._**

## Summary

Wouldn't it be nice to have **ONE PowerShell script that prompts you for required information _(Group, Hub name and Device name)_** when creating or selecting a Hub and for when collecting the required meta-data. Its output could be the required meta-data in temporary environment variables, ready for use by the Quickstarts. _Look no further!_

It's here now.  You run the main PowerShell script **_get-iothub_** in the PS folder. Whilst there are numerous other PowerShell scripts under PS in other folders, these are functions called by the main script. The script displays menus where the user makes selections or choices.

There is one other script that needs to be run once, set-path (run from the prompt in PS foloder as   ```.\set-path``` ). You then can run the main script just by entering ```get-iothub``` as the PS folder is now in the System Path; but only for the life of the  shell. set-path only needs to be run once for a new PowerShell terminal.

- Within an Azure Subscription you have a Resource Group.
- An IoT Hub is a member of a Resource Group.
- A Device belongs to an IoT Hub.
- An IoT Hub and its device both have connection meta-information need by the Quickstart apps.
- The Quickstart apps(as in this repository) get that info from environment variables, and use it to connect to the hub when they run.
- A Hub can also be connected with a Device Provisioning Service (DPS)

## Features

- An textual menu based PowerShell script, ```az-iothub-ps.ps1```, for managing the creation, deletion, selection and interrogation for connection meta-information
- <b><u>CLIRSD:</u></b> Create, List, Select, Interrogate, Run and Delete actions
  - Nb: Run refers to running Quickstart .Net Core apps in the context of the selected entities.
- Numerous additional PowerShell functions in separate PowerShell scripts for implementing the required Azure queries through the Azure Cli API.
- The main script can be run be in autonomous mode where the entity names are supplied as command line parameters to be created, as a csv list.
- This latter mode can now be initiated through a UI by running ```run-ui``` This collects the entity names and verifies their availability before calling az-iothub-ps.
- az-iothub-ps and run-ui can both initiate the Azure Cli login.
- Functions have checks and balances. eg. If creating or deleting an entity, does it exist beforehand, does it exist afterwards?
- You select or create a Resource Group in the Azure Subscription, then an IoT Hub in that group, then a Device and/or a DPS connected to the hub
  - Within the menus you configure the DPS to be connected to the Hub, after selecting both
- **Connectivity Info:** Generates the required context for the selected Hub,Device and DPS in terms of the various connectivity meta-information
  - Eg Hub or Device connection string
  - Manifested as temporary environment variables
    - Option to permanently set the environment variable with Windows (a PS script)
     - Creates scripts to reassert those environment variables as a PowerShell script for Windows and as a .sh script (EXPORTS) for Linux
    - Also generates a launchsettings.json file that can be used with a .Net Core app to generate the environment variables in the app's runtime context
- _**Quickstarts:**_ Azure IoT Hub SDK Quickstart apps are included in the repository such that they all read the required connectivity information from these environment variables
  - Some additional Quickstarts such as a Motor H-Bridge
  - Can embed the environment variables scripts directly into teh Quickstarts ready for copying directly to a remote device such as a RPi
    - eg. PS for IOT-Core or .sh for Rapsian. Or launchsettings.json (works with Windows0.)
  - Also a ```run-apps``` PS script that can simultaneously launch both the simulated Hub and Device on the desktop
- **Azure Sphere:** A fully fledged textual menu for setting up an Azure Sphere, including an Azsphere Comamnd Prompt, as a PowerShell rather than CMD
  - Can log into AzSphere
  - Tenant, WiFi, Update and App Dev submenus that call the various AzSphere API functions for setting up for Azsphere development
  - In another submenu separately perform all of the steps required for connecting an Azsphere app (certification, verification etc) using IOT Hub-DPS connectivity without using the Azure Portal
    - _**OR:Do all that automatically as one menu option**_ from the AzSphere main menu.
    - Both methods include generating an app_manifest.json file with the 3 required meta-data item written into it, ready for copying into an AzSphere app:
      - DPS ID Scope, Hub Connection URL and Tenant ID
      - Specifically for the AzureIoT Sample app from [github Azure/azure-sphere-samples](https://github.com/Azure/azure-sphere-samples/tree/master/Samples/AzureIoT) but only requires GPIO modifications and possibly ComponentId (??) for use in other apps.

<hr>

The Azure IoT Central capabilities have been removed from this branch of the repository. They are though still under development in the **IoT-Central** branch of the repository.  You can clone that by adding ```--branch IoT-Central``` to the git clone command. You might also want to add ```--single-branch``` as well to the git clone command. The iot-central branch functionality is a superset  of the functionality in this branch,except for some tweaks in both branches which will be merged, adding the **Azure IoT Central** functionality to the iot-central branch.

<hr>
Having problems running PowerShell scripts that you have downloaded, for example the ones from here, because they are unsigned. I've created a new GitHub repository [djaus2/sign-me-up-scotty](https://github.com/djaus/sign-me-up-scotty) that can create a local signing authority, create a personal certificate for code signing, and sign an individual PS script with that certificate. And for repository downloads like this, it can recursively sign all PS scripts in a folder and down from there, as well as recursively unsign them!
<hr>

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
5. DPS
6. Environment Variables
7. Quickstart Apps
8. Manage App Data
9. All in one. Get a New: (Group ... Hub in Group ... Device for Hub)
  
  A. Azure Sphere  
  
  R. Reset script globals  
  X. Exit  
  Select action (number). (Default is highlighted) X To exit
</td></tr></table>

_The **get-iothub** PowerShell script Main Menu_

<hr>

![run-ui-1](/PS/images/run-ui-1.png)  
_The **run-ui** PowerShell UI interface_  

Reminder: run-ui runs as PowerShell script.  

![run-ui-1](/PS/images/run-ui-2.png)  
_**run-ui** IS menu driven_

<hr>

## The Quickstart projects and their apps

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
