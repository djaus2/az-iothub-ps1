// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using Microsoft.Azure.Devices.Samples.Common;
using System;
using System.Net.WebSockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

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

                                string MsgOut = "Invalid. Try Help";
                                switch (MsgIn.Substring(0, 3).ToLower())
                                {
                                    case "tem":
                                        MsgOut = "21 C";
                                        break;
                                    case "pre":
                                        MsgOut = "1034.0 hPa";
                                        break;
                                    case "hum":
                                        MsgOut = "67 percent";
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
