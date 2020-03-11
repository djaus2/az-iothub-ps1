// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

// This application uses the Azure IoT Hub device SDK for .NET
// For samples see: https://github.com/Azure/azure-iot-sdk-csharp/tree/master/iothub/device/samples

using System;
using Microsoft.Azure.Devices.Client;
using Newtonsoft.Json;
using System.Text;
using System.Threading.Tasks;

using Iot.Device.CpuTemperature;
using System.Device.I2c;
using Iot.Device.Bmp180;
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
            CpuTemperature _temperature = null;
            Dht11 dht = null;
            Bmp180 i2cBmp280 = null;
            try {
                if((Sensor == Sensors.BMP280) || (Sensor == Sensors.BME280))
                {
                    _temperature = new CpuTemperature();
                    Console.WriteLine("Using harBMP280 or BPE280");   
                }
                else if(Sensor == Sensors.DHT11)
                {
                    //1-Wire:
                    int  pin = 26;
                    dht = new Dht11(pin);
                    Console.WriteLine("Using DHT11");   
                }
                else if (Sensor == Sensors.BMP180)
                {                 
                    // bus id on the raspberry pi 3
                    const int busId = 1;
                    var i2cSettings = new I2cConnectionSettings(busId, Bmp180.DefaultI2cAddress);
                    var i2cDevice = I2cDevice.Create(i2cSettings);
                    i2cBmp280 = new Bmp180(i2cDevice);
                    i2cBmp280.SetSampling(Sampling.Standard);
                    Console.WriteLine("Using BMP100");   
                }
                else{
                    Console.WriteLine("Not using hardware");
                }

                //Only DH12 can use DH12:
                /*I2cConnectionSettings settings = new I2cConnectionSettings(1, DhtSensor.DefaultI2cAddressDht12);
                I2cDevice device = I2cDevice.Create(settings);
                Dht12 dht12 = new Dht12(device);*/
                
            }
            catch (Exception)
            {
                Console.WriteLine("No hardware");
                _temperature = null;
                 dht = null;
                i2cBmp280 = null;
            }

            while (true)
            {
                double currentTemperature = minTemperature + rand.NextDouble() * 15;
                double currentHumidity = minHumidity + rand.NextDouble() * 20;

                if (_temperature != null)
                {
                    if (_temperature.IsAvailable)
                    {
                        Console.WriteLine($"The CPU temperature is {Math.Round(_temperature.Temperature.Celsius, 2)}");
                        currentTemperature = _temperature.Temperature.Celsius;
                        if (Sensor == Sensors.BME280)
                        {
                            //currentHumidity = _temperature.Humidity;
                        }

                    }
                }
                else if (dht != null){
                    currentTemperature = (double) dht.Temperature.Celsius;
                    currentHumidity = dht.Humidity;
                }
                else if (i2cBmp280 != null){
                    currentTemperature = (double) i2cBmp280.ReadTemperature().Celsius;
                    //currentHPressure = (double) i2cBmp280.ReadPressure().Hectopascal;
                }
               /* else if (dht12 != null){
                    currentTemperature = (double)dht12.Temperature.Celsius;
                    currentHumidity = dht12.Humidity;
                }*/

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

                await Task.Delay(1000);
            }
        }

        private enum Sensors  {none,DHT11,BMP180,BMP280,BME280};
        private static Sensors Sensor =    Sensors.none;
        private static void Main(string[] args)
        {
            if (SensorIn != null);
            {
                SensorIn = SensorIn.ToUpper();
                if (SensorIn != "")
                {
                    if (SensorIn == "BMP180")
                    {
                        //Ref: https://github.com/dotnet/iot/tree/master/src/devices/Bmp180


                    }
                    else{
                        switch (SensorIn.Substring(0,3))
                        {
                            case "DHT":
                            //Temp and Pressure
                            Sensor = Sensors.DHT11;
                            break;
                            case "BMP":
                            //Temp and Pressure
                            Sensor = Sensors.BMP280;
                            break;  
                            case "BME":
                            //Temp Pressure and Humidity
                            Sensor = Sensors.BME280;
                            break;
                        }
                    }

                }
            }

            Console.WriteLine("IoT Hub Quickstarts #1 - Simulated device. Ctrl-C to exit.\n");
            Console.WriteLine ("Using Env Var IOTHUB_DEVICE_CONN_STRING = " + s_connectionString );

            // Connect to the IoT hub using the MQTT protocol
            s_deviceClient = DeviceClient.CreateFromConnectionString(s_connectionString, TransportType.Mqtt);
            SendDeviceToCloudMessagesAsync();
            Console.ReadLine();
        }
    }
}
