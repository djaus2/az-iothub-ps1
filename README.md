## az-iothub-ps

# Azure IoT Hub PowerShell Scripts

In the [Azure IoT Hub Quickstarts](https://docs.microsoft.com/en-us/azure/iot-hub/). _take the Quickstart link in the sidebar on left_, a list of steps are repeated on most pages for creating a new Azure IoT Hub from scratch as well as for getting the required Hub connection meta-data. This meta-data is required to be provided as environment variables for the [Quickstart .NET Core Sample apps](https://github.com/Azure-Samples/azure-iot-samples-csharp/archive/master.zip), _(n.b. this is a zip file)_, or provided as command line parameters for the apps. The Quickstart tutorials use the **Azure Cli** (Az Cli) in a **PowerShell** terminal. The UWP app **Azure IoT Hub Toolbox** simplifies this a little, as available as source [GitHub](https://github.com/djaus2/Azure.IoTHub.Toolbox) as well as a ready to run app on the [Microsoft Store](https://www.microsoft.com/en-au/p/azureiothubtoolbox/9pmcf9clttwz?activetab=pivot:overviewtab), with the app's Settings page stepping you through the Hub creation and collection of the meta-data to be used in-app. The Toolbox also requires a PowerShell Az Cli terminal as it supplies the required AZ Cli commands on the clipboard.

**_N.b.: The .NET (Core C#) versions of the apps are the focus here._**

But wouldn't it be nice to have **ONE PowerShell script that prompts you for required information** when creating or selecting a Hub and for when collecting the required meta-data. Its output could be the required meta-data in temporary environment variables, ready for use by the Quickstarts. _Look no further!_
