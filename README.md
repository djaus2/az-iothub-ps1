# az-iothub-ps

Azure IoT Hub PowerShell Scripts

In the [Azure IoT Hub Quickstarts](), a list of steps are repeated on most pages for creating a new Azure IoT Hub from scratch as well as for getting the required Hub connection meta-data. This meta-data is required to be provided as environment variables for the Quickstart .NET Core Sample apps, or provided as command line parameters for the apps. The Quickstart tutorials use the **Azure Cli** (Az Cli) in a **PowerShell** terminal. The **Azure IoT Hub Toolbox** simplifies this a little, as on [GitHub]() as well as a ready to run app on the [Microsoft Store](), with apps setting page stepping you through the Hub creation and collection of the metad-data to be used in-app. The Toolbox also requires a PowerShell Az Cli terminal as it supplies the required AZ Cli commands on the clipbaord.

But wouldn't it be nice to have **ONE PowerShell script that prompts you for required information** when creating or selecting a Hub and for when collecting the required meta-data. Its output could be the required meta-data in temperary enviroment variables, ready for use by the Quickstarts. _Look no further!_
