﻿// Copyright (c) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE file in the project root for full license information.

using Microsoft.Azure.Devices.Samples.Common;
using System;
using System.Net.Sockets;
using System.Net.WebSockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Microsoft.Azure.Devices.Samples
{
    public class DeviceStreamSample
    {
        private ServiceClient _serviceClient;
        private String _deviceId;

        public DeviceStreamSample(ServiceClient deviceClient, String deviceId)
        {
            _serviceClient = deviceClient;
            _deviceId = deviceId;
        }
        
        public async Task RunSampleAsync()
        {
            try
            {
                Console.WriteLine("Service: Sending TestStream");
                DeviceStreamRequest deviceStreamRequest = new DeviceStreamRequest(
                    streamName: "TestStream"
                );

                DeviceStreamResponse result = await _serviceClient.CreateStreamAsync(_deviceId, deviceStreamRequest).ConfigureAwait(false);

                Console.WriteLine("Service: Stream response received: Name={0} IsAccepted={1}", deviceStreamRequest.StreamName, result.IsAccepted);

                if (result.IsAccepted)
                {
                    CancellationToken tok = new CancellationToken(false);
                    using (var stream = await DeviceStreamingCommon.GetStreamingClientAsync(result.Url, result.AuthorizationToken, tok).ConfigureAwait(false))
                    //using (var cancellationTokenSource = new CancellationTokenSource())// 500000))//TimeSpan.FromMinutes(1)))
                    // using (var stream = await DeviceStreamingCommon.GetStreamingClientAsync(result.Url, result.AuthorizationToken, cancellationTokenSource.Token).ConfigureAwait(false))
                    {
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
                        // string MsgOut = "";
                        string MsgIn = "";
                        bool exitNow = false;
                        do
                        {
                            Console.Write("Enter cmd to send: ");
                            var key = Console.ReadKey(false);
                            char ch = key.KeyChar;
                            ch = char.ToUpper(ch);
                            byte[] sendBuffer = Encoding.UTF8.GetBytes(ch.ToString());
                            byte[] receiveBuffer = new byte[1024];

                            await stream.SendAsync(sendBuffer, WebSocketMessageType.Binary, true, tok).ConfigureAwait(false);
                            Console.WriteLine();
                            Console.WriteLine("    Service: Sent stream data: {0}", Encoding.UTF8.GetString(sendBuffer, 0, sendBuffer.Length));

                            var receiveResult = await stream.ReceiveAsync(receiveBuffer, tok).ConfigureAwait(false);
                            MsgIn = Encoding.UTF8.GetString(receiveBuffer, 0, receiveResult.Count);
                            exitNow = (MsgIn.ToLower() == "exiting");
                            Console.WriteLine("        Service: Received stream data: {0}", MsgIn);
                            Console.WriteLine();
                        } while (!exitNow);
                        await stream.CloseAsync(WebSocketCloseStatus.NormalClosure, "Closing", CancellationToken.None).ConfigureAwait(true);
                    }
                }
                else
                {
                    Console.WriteLine("Service: Stream request was rejected by the device");
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine("Service: Got an exception: {0}", ex);
                throw;
            }
        }
    }
}
