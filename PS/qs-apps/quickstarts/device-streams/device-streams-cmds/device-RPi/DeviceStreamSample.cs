// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using Microsoft.Azure.Devices.Samples.Common;
using System;
using System.Net.WebSockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

//using Iot.Device.CpuTemperature;
using System.Device.I2c;
using Iot.Device.DHTxx;

namespace Microsoft.Azure.Devices.Client.Samples
{
    public class DeviceStreamSample
    {
        private DeviceClient _deviceClient;

        public DeviceStreamSample(DeviceClient deviceClient)
        {
            _deviceClient = deviceClient;
        }

        public async Task RunSampleAsync()
        {
            await RunSampleAsync(true).ConfigureAwait(false);
        }

        public static bool state = false;

        public enum Sensors  {none,DHT11,DHT22,BMP180,BMP280,BME280};
        public static Sensors Sensor = Sensors.none;

        public async Task RunSampleAsync(bool acceptDeviceStreamingRequest)
        {

            byte[] buffer = new byte[1024];

            double minTemperature = 20;
            double minHumidity = 60;
            Random rand = new Random();
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
                    dht=null;
                }

  
                
            }
            catch (Exception)
            {
                Console.WriteLine("No hardware");
                //_temperature = null;
                 dht = null;
                //i2cBmp280 = null;
            }

            using (var cancellationTokenSource = new CancellationTokenSource(TimeSpan.FromMinutes(5)))
            {
                Console.WriteLine("Device: Looking for Stream Request.");
                DeviceStreamRequest streamRequest = await _deviceClient.WaitForDeviceStreamRequestAsync(cancellationTokenSource.Token).ConfigureAwait(false);

                if (streamRequest != null)
                {
                    if (acceptDeviceStreamingRequest)
                    {
                        Console.WriteLine("Device: Accepting Stream Request.");
                        string MsgIn = "";
                       
                        await _deviceClient.AcceptDeviceStreamRequestAsync(streamRequest, cancellationTokenSource.Token).ConfigureAwait(false);

                        using (ClientWebSocket webSocket = await DeviceStreamingCommon.GetStreamingClientAsync(streamRequest.Url, streamRequest.AuthorizationToken, cancellationTokenSource.Token).ConfigureAwait(false))
                        {
                            do
                            {
                                WebSocketReceiveResult receiveResult = await webSocket.ReceiveAsync(new ArraySegment<byte>(buffer, 0, buffer.Length), cancellationTokenSource.Token).ConfigureAwait(false);
                                Console.WriteLine("Device: Received stream data: {0}", Encoding.UTF8.GetString(buffer, 0, receiveResult.Count));

                                MsgIn = Encoding.UTF8.GetString(buffer, 0, receiveResult.Count);

                                double currentTemperature = minTemperature + rand.NextDouble() * 15;
                                double currentHumidity = minHumidity + rand.NextDouble() * 20;


                                string MsgOut = "Invalid. Try Help";
                                switch (MsgIn.Substring(0, 3).ToLower())
                                {
                                    case "tem":
                                    case "hum":
                                        MsgOut = "21 C";
                                        if (dht==null)
                                        {
                                            currentTemperature = minTemperature + rand.NextDouble() * 15;
                                            currentHumidity = minHumidity + rand.NextDouble() * 20;
                                        }
                                        else
                                        {
                                            bool lastResult=true;
                                            while (!lastResult)
                                            {
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
                                            }                                       
                                        }
                                        switch (MsgIn.Substring(0, 3).ToLower())
                                        {
                                            case "tem":
                                                MsgOut= $"Temperature: {currentTemperature.ToString("0.0")} °C ";
                                                break;
                                            case "hum":
                                                MsgOut ="35 %";
                                                break;
                                        }                                           
                                        break;
                                    case "pre":
                                        MsgOut = "1034.0 hPa";
                                        break;
                                    case "sta":
                                        MsgOut = string.Format("state = {0}", state);
                                        break;
                                    case "set":
                                        state = true;
                                        MsgOut = string.Format("state = {0}", state);
                                        break;
                                    case "clr":
                                        state = false;
                                        MsgOut = string.Format("state = {0}", state);
                                        break;
                                    case "tog":
                                        state = !state;
                                        MsgOut = string.Format("state = {0}", state);
                                        break;
                                    case "hel":
                                        MsgOut = "Help: Commands are:\ntemperature,pressure,humidity,state,set,clr,toggle,help,close\nOnly first 3 letters of cmd matter.";
                                        break;
                                    case "clo":
                                        MsgOut = "Device Closing";
                                        break;
                                    default:
                                        MsgOut = "Invalid request. Try Help";
                                        break;
                                }

                                byte[] sendBuffer = Encoding.UTF8.GetBytes(MsgOut);
                                

                                await webSocket.SendAsync(new ArraySegment<byte>(sendBuffer, 0, sendBuffer.Length), WebSocketMessageType.Binary, true, cancellationTokenSource.Token).ConfigureAwait(false);
                                Console.WriteLine("Device: Sent stream data: {0}", Encoding.UTF8.GetString(sendBuffer, 0, sendBuffer.Length));
                            } while (MsgIn.ToLower() != "close");

                            await webSocket.CloseAsync(WebSocketCloseStatus.NormalClosure, String.Empty, cancellationTokenSource.Token).ConfigureAwait(false);
                        }
                    }
                    else
                    {
                        await _deviceClient.RejectDeviceStreamRequestAsync(streamRequest, cancellationTokenSource.Token).ConfigureAwait(false);
                    }
                }

                await _deviceClient.CloseAsync().ConfigureAwait(false);
            }
        }
    }
}
