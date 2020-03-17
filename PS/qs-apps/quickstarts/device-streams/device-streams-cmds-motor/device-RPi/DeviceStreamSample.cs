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


// To get the dotnet/io packages:
// install-Package System.Device.Gpio -Version 1.1.0-prerelease.20153
// Install-Package Iot.Device.Bindings -Version 1.1.0-prerelease.20153.1
using System.Device.Gpio;
using Iot.Device;



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

        public async Task RunSampleAsync(bool acceptDeviceStreamingRequest)
        {

            byte[] buffer = new byte[1024];
            //GPIO Pin numbers:
            //=================
            var pinFwd = 17; // <- Brd Pin 11            If hi and pinBack is lo motor goes fwd
            var pinRev = 27; // <- Brd Pin 13             if hi and pinFwd is lo motor goes back (reverse)
            var pinEn = 22;  // <- Brd Pin 15            Overall enable/disable  hi/lo

            //Nb: if pinFwd=pinRev hi or lo then its brake

            Console.WriteLine($"Let's control a DC motor!");
            try{
            using (GpioController controller = new GpioController())
            {
                controller.OpenPin(pinEn, PinMode.Output);
                Console.WriteLine($"GPIO pin enabled for use (Output:Enable): {pinEn}");
                controller.OpenPin(pinRev, PinMode.Output);
                Console.WriteLine($"GPIO pin enabled for use (Output:Reverse): {pinRev}");
                controller.OpenPin(pinFwd, PinMode.Output);
                Console.WriteLine($"GPIO pin enabled for use (Output:Forward): {pinFwd}");

                controller.Write(pinEn, PinValue.Low);
                controller.Write(pinFwd, PinValue.Low);
                controller.Write(pinRev, PinValue.Low);

                bool exitNow = false;

                using (var cancellationTokenSource = new CancellationTokenSource(TimeSpan.FromMinutes(10)))
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


                                    string MsgOut = "CMD NOT OK";
                                    if (MsgIn=="")
                                    {
                                        MsgOut = "Empty CMD";
                                    }
                                    else{
                                        char ch = MsgIn[0];
                                        bool fwdState = (bool)controller.Read(pinFwd);
                                        bool revState = (bool)controller.Read(pinRev);
                                        bool enState = (bool) controller.Read(pinEn);
                                        switch (char.ToUpper(ch))
                                        {
                                            case '0':
                                                controller.Write(pinFwd, PinValue.Low);
                                                Console.WriteLine("    Pin: {0} State: {1}", pinFwd, controller.Read(pinFwd));
                                                break;
                                            case '1':
                                                controller.Write(pinFwd, PinValue.High);
                                                Console.WriteLine("    Pin: {0} State: {1}", pinFwd, controller.Read(pinFwd));
                                                break;
                                            case '2':
                                                controller.Write(pinRev, PinValue.Low);
                                                Console.WriteLine("    Pin: {0} State: {1}", pinRev, controller.Read(pinRev));
                                                break;
                                            case '3':
                                                controller.Write(pinRev, PinValue.High);
                                                Console.WriteLine("    Pin: {0} State: {1}", pinRev, controller.Read(pinRev));
                                                break;
                                            case '4':
                                                controller.Write(pinEn, PinValue.Low);
                                                Console.WriteLine("    Pin: {0} State: {1}", pinEn, controller.Read(pinEn));
                                                break;
                                            case '5':
                                                controller.Write(pinEn, PinValue.High);
                                                Console.WriteLine("    Pin: {0} State: {1}", pinEn, controller.Read(pinEn));
                                                break;

                                            case 'F': //Forward
                                                //Fwd: Take action so as to eliminate undesirable intermediate state/s
                                                if (fwdState && revState)
                                                {
                                                    //Is braked (hi)
                                                    controller.Write(pinRev, PinValue.Low);
                                                    Console.WriteLine("    Pin: {0} State: {1}", pinRev, controller.Read(pinRev));
                                                }
                                                else if (!fwdState && revState)
                                                {
                                                    //Is Rev. Brake first
                                                    controller.Write(pinRev, PinValue.Low);
                                                    controller.Write(pinFwd, PinValue.High);
                                                    Console.WriteLine("    Pin: {0} State: {1}", pinFwd, controller.Read(pinFwd));
                                                    Console.WriteLine("    Pin: {0} State: {1}", pinRev, controller.Read(pinRev));
                                                }
                                                else if (!fwdState && !revState)
                                                {
                                                    //Is braked (lo)
                                                    controller.Write(pinFwd, PinValue.High);
                                                    Console.WriteLine("    Pin: {0} State: {1}", pinFwd, controller.Read(pinFwd));
                                                }
                                                else if (fwdState && !revState)
                                                {
                                                    //Is fwd
                                                }
                                                if (enState)
                                                    MsgOut ="Motor going fwd";
                                                else
                                                    MsgOut = "Fwd but not enabled";
                                                break;
                                            case 'R': // Reverse
                                                if (fwdState && revState)
                                                {
                                                    //Is braked (hi)
                                                    controller.Write(pinFwd, PinValue.Low);
                                                    Console.WriteLine("    Pin: {0} State: {1}", pinFwd, controller.Read(pinFwd));
                                                }
                                                else if (!fwdState && revState)
                                                {
                                                    //Is reverse
                                                }
                                                else if (!fwdState && !revState)
                                                {
                                                    //Is braked (lo)
                                                    controller.Write(pinRev, PinValue.High);
                                                    Console.WriteLine("    Pin: {0} State: {1}", pinRev, controller.Read(pinRev));
                                                }
                                                else if (fwdState && !revState)
                                                {
                                                    //Is fwd: Brake first
                                                    controller.Write(pinFwd, PinValue.Low);
                                                    controller.Write(pinRev, PinValue.High);
                                                    Console.WriteLine("    Pin: {0} State: {1}", pinFwd, controller.Read(pinFwd));
                                                    Console.WriteLine("    Pin: {0} State: {1}", pinRev, controller.Read(pinRev));
                                                }
                                                 if (enState)
                                                    MsgOut ="Motor going rev";
                                                else
                                                    MsgOut = "Rev but not enabled";
                                                break;
                                            case 'B': //Brake
                                                if (fwdState && revState)
                                                {
                                                    //Is braked (hi)
                                                }
                                                else if (!fwdState && revState)
                                                {
                                                    //Is Rev: Brake lo
                                                    controller.Write(pinRev, PinValue.Low);
                                                    Console.WriteLine("    Pin: {0} State: {1}", pinRev, controller.Read(pinRev));
                                                }
                                                else if (!fwdState && !revState)
                                                {
                                                    //Is braked (lo)
                                                }
                                                else if (fwdState && !revState)
                                                {
                                                    //Is fwd: Brake lo
                                                    controller.Write(pinFwd, PinValue.Low);
                                                    Console.WriteLine("    Pin: {0} State: {1}", pinFwd, controller.Read(pinFwd));
                                                }
                                                if (enState)
                                                    MsgOut ="Motor is braked";
                                                else
                                                    MsgOut = "Braked but not enabled";;
                                                break;
                                            case 'E': //Enable
                                                controller.Write(pinEn, PinValue.High);
                                                Console.WriteLine("    Pin: {0} State: {1}", pinEn, controller.Read(pinEn));
                                                MsgOut = "Motor Enabled";
                                                break;
                                            case 'D': //Disable
                                                controller.Write(pinEn, PinValue.Low);
                                                Console.WriteLine("    Pin: {0} State: {1}", pinEn, controller.Read(pinEn));
                                                MsgOut ="Motor Disabled";
                                                break;
                                            case 'Q':
                                                MsgOut ="Exiting";
                                                exitNow = true;
                                                break;
                                            //case default:
                                            //    MsgOut = "Invalid command";
                                            //    break;
                                        }                             
                                    }

                                    byte[] sendBuffer = Encoding.UTF8.GetBytes(MsgOut);
                                    

                                    await webSocket.SendAsync(new ArraySegment<byte>(sendBuffer, 0, sendBuffer.Length), WebSocketMessageType.Binary, true, cancellationTokenSource.Token).ConfigureAwait(false);
                                    Console.WriteLine("        Device: Sent stream data: {0}", Encoding.UTF8.GetString(sendBuffer, 0, sendBuffer.Length));
                                    Console.WriteLine();
                                } while (!exitNow);

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
            } catch (Exception)
            {
                Console.WriteLine("Hardware not available");
               
                using (var cancellationTokenSource = new CancellationTokenSource(TimeSpan.FromMinutes(10)))
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
                                bool fwdState = false;;
                                bool revState = false;
                                bool enState = false;
                                bool exitNow = false;
                                do
                                {
                                    WebSocketReceiveResult receiveResult = await webSocket.ReceiveAsync(new ArraySegment<byte>(buffer, 0, buffer.Length), cancellationTokenSource.Token).ConfigureAwait(false);
                                    Console.WriteLine("Device: Received stream data: {0}", Encoding.UTF8.GetString(buffer, 0, receiveResult.Count));

                                    MsgIn = Encoding.UTF8.GetString(buffer, 0, receiveResult.Count);


                                    string MsgOut = "CMD NOT OK";
                                    if (MsgIn=="")
                                    {
                                        MsgOut = "Empty CMD";
                                    }
                                    else{
                                        char ch = MsgIn[0];
                                        string PinValueLow ="Lo";
                                        string PinValueHigh = "Hi";
                                        switch (char.ToUpper(ch))
                                        {
                                            case '0':
                                                Console.WriteLine("    pinFwd " + PinValueLow);
                                                fwdState = false;
                                                MsgOut = "Fwd lo";
                                                break;
                                            case '1':
                                                Console.WriteLine("    pinFwd " + PinValueHigh);
                                                fwdState = true;
                                                MsgOut = "Fwd hi";
                                                break;
                                            case '2':
                                                Console.WriteLine("    pinRev" + PinValueLow);
                                                revState=false;
                                                MsgOut = "Rev lo";
                                                break;
                                            case '3':
                                                Console.WriteLine("    pinRev" + PinValueHigh);
                                                revState=true;
                                                MsgOut = "Rev hi";
                                                break;
                                            case '4':
                                                Console.WriteLine("    pinEn" + PinValueLow);
                                                MsgOut = "En lo";
                                                break;
                                            case '5':
                                                Console.WriteLine("    pinEn" + PinValueHigh);
                                                MsgOut = "En Hi";
                                                break;

                                            case 'F': //Forward
                                                //Fwd: Take action so as to eliminate undesirable intermediate state/s
                                                if (fwdState && revState)
                                                {
                                                    //Is braked (hi)
                                                    Console.WriteLine("    pinRev " + PinValueLow);
                                                    revState=false;
                                                }
                                                else if (!fwdState && revState)
                                                {
                                                    //Is Rev. Brake first
                                                    Console.WriteLine("    pinRev " + PinValueLow);
                                                    Console.WriteLine("    pinFwd " + PinValueHigh);
                                                    fwdState = true;
                                                    revState=false;
                                                }
                                                else if (!fwdState && !revState)
                                                {
                                                    //Is braked (lo)
                                                    Console.WriteLine("    pinFwd " + PinValueHigh);
                                                    fwdState = true;
                                                }
                                                else if (fwdState && !revState)
                                                {
                                                    //Is fwd
                                                }
                                                if (enState)
                                                    MsgOut ="Motor going fwd";
                                                else
                                                    MsgOut = "Fwd but not enabled";
                                                break;
                                            case 'R': // Reverse
                                                if (fwdState && revState)
                                                {
                                                    //Is braked (hi)
                                                    Console.WriteLine("    pinFwd " + PinValueLow);
                                                    fwdState = false;
                                                }
                                                else if (!fwdState && revState)
                                                {
                                                    //Is reverse
                                                }
                                                else if (!fwdState && !revState)
                                                {
                                                    //Is braked (lo)
                                                    Console.WriteLine("    pinRev " + PinValueHigh);
                                                    revState=true;
                                                }
                                                else if (fwdState && !revState)
                                                {
                                                    //Is fwd: Brake first
                                                    Console.WriteLine("    pinFwd " + PinValueLow);
                                                    Console.WriteLine("    pinRev " + PinValueHigh);
                                                    fwdState = false;
                                                    revState=true;
                                                }
                                                if (enState)
                                                    MsgOut ="Motor going rev";
                                                else
                                                    MsgOut = "Rev but not enabled";
                                                break;
                                            case 'B': //Brake
                                                if (fwdState && revState)
                                                {
                                                    //Is braked (hi)
                                                }
                                                else if (!fwdState && revState)
                                                {
                                                    //Is Rev: Brake lo
                                                    Console.WriteLine("    pinRev " + PinValueLow);
                                                    revState=false;;
                                                }
                                                else if (!fwdState && !revState)
                                                {
                                                    //Is braked (lo)
                                                }
                                                else if (fwdState && !revState)
                                                {
                                                    //Is fwd: Brake lo
                                                    Console.WriteLine("    pinFwd " + PinValueLow);
                                                    fwdState = false;
                                                }
                                                if (enState)
                                                    MsgOut ="Motor braked";
                                                else
                                                    MsgOut = "Braked but not enabled";
                                                break;
                                            case 'E': //Enable
                                                enState = true;
                                                Console.WriteLine("    pinEn " + PinValueHigh);
                                                MsgOut ="Motor enabled";
                                                break;
                                            case 'D': //Disable
                                                enState = false;
                                                Console.WriteLine("    pinEn " + PinValueLow);
                                                MsgOut ="Motor disabled";
                                                break;
                                            case 'Q':
                                                MsgOut ="Exiting";
                                                exitNow = true;
                                                break;
                                            //case default:
                                            //    MsgOut = "Invalid command";
                                            //    break;
                                        }                             
                                    } 

                                    byte[] sendBuffer = Encoding.UTF8.GetBytes(MsgOut);
                                    

                                    await webSocket.SendAsync(new ArraySegment<byte>(sendBuffer, 0, sendBuffer.Length), WebSocketMessageType.Binary, true, cancellationTokenSource.Token).ConfigureAwait(false);
                                    Console.WriteLine("        Device: Sent stream data: {0}", Encoding.UTF8.GetString(sendBuffer, 0, sendBuffer.Length));
                                    Console.WriteLine();
                                } while (!exitNow);

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
}
