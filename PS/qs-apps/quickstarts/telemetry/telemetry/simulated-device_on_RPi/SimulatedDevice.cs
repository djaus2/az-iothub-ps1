// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// This application uses the Azure IoT Hub device SDK for .NET
// For samples see: https://github.com/Azure/azure-iot-sdk-csharp/tree/master/iothub/device/samples

using System;
using Microsoft.Azure.Devices.Client;
using Newtonsoft.Json;
using System.Text;
using System.Threading.Tasks;

//using Iot.Device.CpuTemperature;
using System.Device.I2c;
using Iot.Device.DHTxx;
using System.Threading;

namespace simulated_device
{
    class SimulatedDevice
    {
        
        private static DeviceClient s_deviceClient;

    

        // The device connection string to authenticate the device with your IoT hub.
        // Using the Azure CLI:
        // az iot hub device-identity show-connection-string --hub-name {YourIoTHubName} --device-id MyDotnetDevice --output table
        ////private readonly static string s_connectionString = "{Your device connection string here}";
        
        // For this sample either
        // - pass this value as a command-prompt argument
        // - set the IOTHUB_DEVICE_CONN_STRING environment variable 
        // - create a launchSettings.json (see launchSettings.json.template) containing the variable
        private static string s_connectionString = Environment.GetEnvironmentVariable("IOTHUB_DEVICE_CONN_STRING");
        private static string SensorIn = Environment.GetEnvironmentVariable("SENSOR");



        // Async method to send simulated telemetry
        private static async void SendDeviceToCloudMessagesAsync()
        {
            // Initial telemetry values
            double minTemperature = 20;
            double minHumidity = 60;
            Random rand = new Random();
            //CpuTemperature _temperature = null;
            Dht22 dht = null;
            //Bmp180 i2cBmp280 = null;
            Console.WriteLine ("Using Sensor {0}",Sensor );
            try {
               if(Sensor == Sensors.DHT22)
                {
                    //1-Wire:
                    int  pin = 26;
                    dht = new Dht22(pin);
                    Console.WriteLine("Using DHT22");   
                }
                else{
                    Console.WriteLine("Not using hardware");
                }

  
                
            }
            catch (Exception)
            {
                Console.WriteLine("No hardware");
                //_temperature = null;
                 dht = null;
                //i2cBmp280 = null;
            }

            while (true)
            {
                bool lastResult=true;
                double currentTemperature = minTemperature + rand.NextDouble() * 15;
                double currentHumidity = minHumidity + rand.NextDouble() * 20;
                if (dht != null){
                    currentTemperature = (double) dht.Temperature.Celsius;
                    bool result1 = dht.IsLastReadSuccessful;
                    currentHumidity = dht.Humidity;
                    bool result2 = dht.IsLastReadSuccessful;
                    if (!result1 || !result2) 
                    {
                        Console.Write(".");
                        lastResult = false;
                    }
                    else
                    {
                        //Sanity Check
                        bool resultIsValid = true;
                        if (currentTemperature is double.NaN)
                            resultIsValid = false;
                        else if (currentHumidity is double.NaN)
                            resultIsValid = false;
                        if (!resultIsValid)
                        {
                            Console.Write("#");
                            lastResult = false;
                        }
                        else
                        {
                            bool resultIsSane = true;
                            if ((currentTemperature> 100) || (currentTemperature< -20))
                                resultIsSane = false;
                            else if ((currentHumidity> 100) || (currentHumidity> 100))
                                resultIsSane = false;
                            if (!resultIsSane)
                            {
                                Console.Write("x");
                                lastResult = false;
                            }
                            else
                            {

                                if (!lastResult)
                                    Console.WriteLine("");
                                lastResult = true;
                                currentTemperature = Math.Round(currentTemperature,4);
                                currentHumidity = Math.Round(currentHumidity,4);
                                Console.Write($"Temperature: {currentTemperature.ToString("0.0")} °C ");
                                Console.Write($"Humidity: { currentHumidity.ToString("0.0")} % ");
                                Console.WriteLine("");
                            }
                        }
                    }                   
                }
             
                if (lastResult){
                    // Create JSON message
                    var telemetryDataPoint = new
                    {
                        temperature = currentTemperature,
                        humidity = currentHumidity
                    };
                    var messageString = JsonConvert.SerializeObject(telemetryDataPoint);
                    var message = new Message(Encoding.ASCII.GetBytes(messageString));

                    // Add a custom application property to the message.
                    // An IoT hub can filter on these properties without access to the message body.
                    message.Properties.Add("temperatureAlert", (currentTemperature > 30) ? "true" : "false");

                    // Send the telemetry message
                    await s_deviceClient.SendEventAsync(message);
                    Console.WriteLine("{0} > Sending message: {1}", DateTime.Now, messageString);
                }

                await Task.Delay(2000);
            }
        }

        private enum Sensors  {none,DHT11,DHT22,BMP180,BMP280,BME280};
        private static Sensors Sensor =    Sensors.none;
        private static void Main(string[] args)
        {
            Sensor = Sensors.DHT22;

            Console.WriteLine("IoT Hub Quickstarts #1 - Simulated device. Ctrl-C to exit.\n");
            Console.WriteLine ("Using Env Var IOTHUB_DEVICE_CONN_STRING = " + s_connectionString );
            Console.WriteLine ("Using Sensor {0}",Sensor );

            // Connect to the IoT hub using the MQTT protocol
            s_deviceClient = DeviceClient.CreateFromConnectionString(s_connectionString, TransportType.Mqtt);
            SendDeviceToCloudMessagesAsync();
            Console.ReadLine();
        }
    }
}
