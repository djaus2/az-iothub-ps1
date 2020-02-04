## az-iothub-ps

# Azure IoT Hub PowerShell Scripts

In the [Azure IoT Hub Quickstarts](https://docs.microsoft.com/en-us/azure/iot-hub/). _take the Quickstart link in the sidebar on left_, a list of steps are repeated on most pages for creating a new Azure IoT Hub from scratch as well as for getting the required Hub connection meta-data. This meta-data is required to be provided as environment variables for the [Quickstart .NET Core Sample apps](https://github.com/Azure-Samples/azure-iot-samples-csharp/archive/master.zip), _(n.b. this is a zip file)_, or provided as command line parameters for the apps. The Quickstart tutorials use the **Azure Cli** (Az Cli) in a **PowerShell** terminal. The UWP app **Azure IoT Hub Toolbox** simplifies this a little, as available as source [GitHub](https://github.com/djaus2/Azure.IoTHub.Toolbox) as well as a ready to run app on the [Microsoft Store](https://www.microsoft.com/en-au/p/azureiothubtoolbox/9pmcf9clttwz?activetab=pivot:overviewtab), with the app's Settings page stepping you through the Hub creation and collection of the meta-data to be used in-app. The Toolbox also requires a PowerShell Az Cli terminal as it supplies the required AZ Cli commands on the clipboard.

**_N.b.: The .NET (Core C#) versions of the apps are the focus here._**

But wouldn't it be nice to have **ONE PowerShell script that prompts you for required information** when creating or selecting a Hub and for when collecting the required meta-data. Its output could be the required meta-data in temporary environment variables, ready for use by the Quickstarts. _Look no further!_

It's here now.  You run the manin PowerShell script **_get-iothub_** in teh PS folder. Whilst there are numerous other PowerShell script under PS in other folders, there are functions called by the main script. The script displays menus where the user makes selections or choices.

There is one other script that needs to be run once, set-path (run from the prompt in PS foloder as .\set-path). You then can run the main script just by entering ```get-iothub``` as teh PS folder is now in the System Path; but only for the life of the  shell. set-path only needs to be run once for a new PowerShell terminal.

Within an Azure Subscription you have a Resource Group.
An IoT Hub is an element of a Resource Group.
A Device belongs to an IoT Hub.

## Creating an IoT and subservient Device
- Select the Subscription to use _(Normally only one option here)_
- Create a Group ( or use an existing one)  _(Group option in Main Menu)_
- Create an IoT Hub (or use an existing one) _(Hub option in Main Menu)_
- Create a Device (or select an existing one) _(Device opton in Main Menu)_

Read more on mu blog [http://www.sportronics.com.au](http://www.sportronics.com.au) 
Nb: Nothing there yet on this ..comin.

Enjoy!
