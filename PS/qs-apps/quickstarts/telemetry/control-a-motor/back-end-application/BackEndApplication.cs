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

        private static string s_DeviceName = Environment.GetEnvironmentVariable("DEVICE_NAME");



        // Invoke the direct method on the device, passing the payload
        private static async Task InvokeMethod(int period)
        {
            var methodInvocation = new CloudToDeviceMethod("Control Motorl") { ResponseTimeout = TimeSpan.FromSeconds(30) };
            methodInvocation.SetPayloadJson(period.ToString());

            // Invoke the direct method asynchronously and get the response from the simulated device.
            var response = await s_serviceClient.InvokeDeviceMethodAsync(s_DeviceName, methodInvocation);

            Console.WriteLine("Response status: {0}, payload:", response.Status);
            Console.WriteLine(response.GetPayloadAsJson());
        }

        private static void Main(string[] args)
        {
            // Create a ServiceClient to communicate with service-facing endpoint on your hub.
            s_serviceClient = ServiceClient.CreateFromConnectionString(s_connectionString);
            



            Console.WriteLine("IoT Hub Quickstarts #2 - Back-end application.\n");
            Console.WriteLine ("Using Env Var IOTHUB_CONN_STRING_CSHARP = " + s_connectionString );
            Console.WriteLine ("Using Env Var DEVICE_NAME (N.b.Same as DEVICE_ID) = " + s_DeviceName );         

            Console.WriteLine();
            Console.WriteLine("Motor Commands:");
            Console.WriteLine("===============");
            Console.WriteLine("E: Enable");
            Console.WriteLine("D: Disable");
            Console.WriteLine("F: Forwards");
            Console.WriteLine("R: Reverse");
            Console.WriteLine("B: Brake");
            Console.WriteLine("Fwd, Rev and Brake don't apply  until enabled.");
            Console.WriteLine("Q: Quit");
            Console.WriteLine();
            Console.WriteLine("Press Enter to continue when the Device is receptives.");
            Console.ReadLine();
            bool done = false;
            do
            {
                Console.Write(" Enter cmd to send: ");
                var key = Console.ReadKey(false);
                char ch = key.KeyChar;
                ch = char.ToUpper(ch);
                InvokeMethod((int)(ch)).GetAwaiter().GetResult();

                if (ch =='Q')
                {
                    done = true;
                }

            } while (!done);

            Console.WriteLine("Done");

        }
    }
}
