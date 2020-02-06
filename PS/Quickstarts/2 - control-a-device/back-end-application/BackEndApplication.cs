// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// This application uses the Azure IoT Hub service SDK for .NET
// For samples see: https://github.com/Azure/azure-iot-sdk-csharp/tree/master/iothub/service
using System;
using System.Threading.Tasks;
using Microsoft.Azure.Devices;

namespace back_end_application
{
    class BackEndApplication
    {
        private static ServiceClient s_serviceClient;
        
        // Connection string for your IoT Hub
        // az iot hub show-connection-string --hub-name {your iot hub name} --policy-name service
        ////private readonly static string s_connectionString = "{Your service connection string here}";

        // For this sample either:
        // - pass this value as a command-prompt argument
        // - set the IOTHUB_CONN_STRING_CSHARP environment variable 
        // - create a launchSettings.json (see launchSettings.json.template) containing the variable
        private static string s_connectionString = Environment.GetEnvironmentVariable("IOTHUB_CONN_STRING_CSHARP");



        // Invoke the direct method on the device, passing the payload
        private static async Task InvokeMethod(int period)
        {
            var methodInvocation = new CloudToDeviceMethod("SetTelemetryInterval") { ResponseTimeout = TimeSpan.FromSeconds(30) };
            methodInvocation.SetPayloadJson(period.ToString());

            // Invoke the direct method asynchronously and get the response from the simulated device.
            var response = await s_serviceClient.InvokeDeviceMethodAsync("Poll", methodInvocation);

            Console.WriteLine("Response status: {0}, payload:", response.Status);
            Console.WriteLine(response.GetPayloadAsJson());
        }

        private static void Main(string[] args)
        {
            // Create a ServiceClient to communicate with service-facing endpoint on your hub.
            s_serviceClient = ServiceClient.CreateFromConnectionString(s_connectionString);

            Console.WriteLine("IoT Hub Quickstarts #2 - Back-end application.\n");
            
            Console.WriteLine("Press Enter to continue when the Simulated-Device-2 is sending messages.");
            Console.ReadLine();
            Console.WriteLine("1/4 Setting period to 10s");
            InvokeMethod(10).GetAwaiter().GetResult();

            Console.WriteLine("2/4 Press Enter to change period again(15s)");
            Console.ReadLine();
            InvokeMethod(15).GetAwaiter().GetResult();

            Console.WriteLine("3/4 Press Enter to change period again (5s)");
            Console.ReadLine();
            InvokeMethod(5).GetAwaiter().GetResult();
            
            Console.WriteLine("4/4 Press Enter to change period again (2s)");
            Console.ReadLine();
            InvokeMethod(2).GetAwaiter().GetResult();
            
            Console.WriteLine("Done: Press Enter signal device to close.");
            Console.ReadLine();
            InvokeMethod(0).GetAwaiter().GetResult();

            Console.WriteLine("Done: Press Enter to exit.");
            Console.ReadLine();

        }
    }
}
