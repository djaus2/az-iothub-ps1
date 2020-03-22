// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// This application uses the Azure IoT Hub device SDK for .NET
// For samples see: https://github.com/Azure/azure-iot-sdk-csharp/tree/master/iothub/device/samples

using System;
using Microsoft.Azure.Devices.Client;
using Newtonsoft.Json;
using System.Text;
using System.Threading.Tasks;


using System.Threading;

namespace simulated_device
{
    class SimulatedDevice
    {
        private static DeviceClient s_deviceClient;

        // The device connection string to authenticate the device with your IoT hub.
        // Using the Azure CLI:
        // az iot hub device-identity show-connection-string --hub-name {YourIoTHubName} --device-id MyDotnetDevice --output table
        //// private readonly static string s_connectionString = "{Your device connection string here}";
        private static string s_connectionString = Environment.GetEnvironmentVariable("IOTHUB_DEVICE_CONN_STRING");

        private static int s_telemetryInterval = 5; // Seconds

        private static AutoResetEvent waitHandleIn = null;
        private static AutoResetEvent waitHandleOut = null;
        private static string MsgIn = "";
        private static string MssgOut = "";






        // Handle the direct method call
        private static Task<MethodResponse> SetTelemetryInterval(MethodRequest methodRequest, object userContext)
        {
            var data = Encoding.UTF8.GetString(methodRequest.Data);

            // Check the payload is a single integer value
            if (Int32.TryParse(data, out s_telemetryInterval))
            {
                Console.ForegroundColor = ConsoleColor.Green;
                Console.WriteLine("Telemetry interval set to {0} seconds", data);
                Console.ResetColor();
                //MsgIn = ((char)s_telemetryInterval).ToString();
                //waitHandleIn.Set();             

                // Acknowlege the direct method call with a 200 success message

                char cmd = (char)s_telemetryInterval;
                string MsgOut = HBridge.RunMotor(cmd, null);

                string result = "{\"result\":\"Executed direct method: " + methodRequest.Name + "\"}";
                var res = new MethodResponse(Encoding.UTF8.GetBytes(result), 200);
                return Task.FromResult(res);
            }
            else
            {
                // Acknowlege the direct method call with a 400 error message
                string result = "{\"result\":\"Invalid parameter\"}";
                return Task.FromResult(new MethodResponse(Encoding.UTF8.GetBytes(result), 400));
            }
        }

        // Async method to send simulated telemetry

        private static async Task SendDeviceToCloudMessagesAsync()
        {
;
            CancellationTokenSource cancel = new CancellationTokenSource();
            

            while (!HBridge.ExitNow)
            {

                //waitHandleOut.WaitOne();

                // Create JSON message
                //var telemetryDataPoint = HBridge.MotorState;
                //var telemetryDataPoint = new
                //{
                //     fwdState = HBridge.FwdState,
                //     revState = HBridge.RevState,
                //     enState = HBridge.EnState
                //};
                var messageString = JsonConvert.SerializeObject(HBridge.MotorState);
                //var messageString = JsonConvert.SerializeObject(telemetryDataPoint);
                var message = new Message(Encoding.ASCII.GetBytes(messageString));

                // Add a custom application property to the message.
                // An IoT hub can filter on these properties without access to the message body.
                message.Properties.Add("MotorOff", (HBridge.MotorState.EnState) ? "true" : "false");
                message.Properties.Add("MotorOn", (HBridge.MotorState.EnState) ? "false" : "true");

                // Send the telemetry message
                await s_deviceClient.SendEventAsync(message);
                Console.WriteLine("{0} > Sending message: {1}", DateTime.Now, messageString);

                if (s_telemetryInterval == 0)
                    return;
                await Task.Delay(4 * 1000);
            }

           
        }
        private static void Main(string[] args)
        {
            Console.WriteLine("IoT Hub Quickstarts #2 - Simulated device. Ctrl-C to exit.\n");

            // Connect to the IoT hub using the MQTT protocol
            s_deviceClient = DeviceClient.CreateFromConnectionString(s_connectionString, TransportType.Mqtt);
            Console.WriteLine ("Using Env Var IOTHUB_DEVICE_CONN_STRING = " + s_connectionString );

            waitHandleIn = new AutoResetEvent(false);
            waitHandleOut = new AutoResetEvent(false);

        // Create a handler for the direct method call
            s_deviceClient.SetMethodHandlerAsync("ControlMotor", SetTelemetryInterval, null).Wait();
            SendDeviceToCloudMessagesAsync().GetAwaiter().GetResult();

            Console.WriteLine("Done: Press Enter to exit.");
            Console.ReadLine();
        }
    }
}
