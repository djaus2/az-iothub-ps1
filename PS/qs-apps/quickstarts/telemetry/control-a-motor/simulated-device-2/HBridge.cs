using System;
using System.Collections.Generic;
using System.Text;

// To get the dotnet/io packages:
// install-Package System.Device.Gpio -Version 1.1.0-prerelease.20153
// Install-Package Iot.Device.Bindings -Version 1.1.0-prerelease.20153.1
using System.Device.Gpio;
using Iot.Device;
using System.Threading;

namespace simulated_device
{

    public static class HBridge
    {
        public class _MotorState
        {
            public  bool FwdState = false;
            public  bool RevState = false;
            public  bool EnState = false;
        }

        public static _MotorState MotorState;

        public static bool ExitNow = false;
        public static bool UsingHW = false;

        //=================
        private static int pinFwd = 17; // <- Brd Pin 11            If hi and pinBack is lo motor goes fwd
        private static int pinRev = 27; // <- Brd Pin 13             if hi and pinFwd is lo motor goes back (reverse)
        private static int pinEn = 22;  // <- Brd Pin 15            Overall enable/disable  hi/lo

        private static GpioController controller;


        const string PinValueLow = "Lo";
        const string PinValueHigh = "Hi";

        static HBridge()
        {
            MotorState = new _MotorState();
            try
            {
                Console.WriteLine($"Let's control a DC motor!");
                controller = new GpioController();
                controller.OpenPin(pinEn, PinMode.Output);
                Console.WriteLine($"GPIO pin enabled for use (Output:Enable): {pinEn}");
                controller.OpenPin(pinRev, PinMode.Output);
                Console.WriteLine($"GPIO pin enabled for use (Output:Reverse): {pinRev}");
                controller.OpenPin(pinFwd, PinMode.Output);
                Console.WriteLine($"GPIO pin enabled for use (Output:Forward): {pinFwd}");

                controller.Write(pinEn, PinValue.Low);
                controller.Write(pinFwd, PinValue.Low);
                controller.Write(pinRev, PinValue.Low);

               MotorState.FwdState = (bool)controller.Read(pinFwd);
                MotorState.RevState = (bool)controller.Read(pinRev);
                MotorState.EnState = (bool)controller.Read(pinEn);
                UsingHW = true;
                Console.WriteLine("Hardware is available");
            } catch (Exception ex)
            {
                UsingHW = false;
                MotorState.FwdState = false;
                MotorState.RevState = false;
                MotorState.EnState = false;
                Console.WriteLine("Hardware not available");
            }
                                
        }
        public static string RunMotor(char cmd, CancellationTokenSource cancellationTokenSource)
        {

            byte[] buffer = new byte[1024];

            bool exitNow = false;
            string MsgOut = "";

            //Nb: if pinFwd=pinRev hi or lo then its brake


            using (cancellationTokenSource)
            {
                if (UsingHW)
                {


                    MsgOut = "CMD NOT OK";
                    if (cmd == '\0')
                    {
                        return MsgOut;
                    }
                    else
                    {
                        switch (char.ToUpper(cmd))
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
                                if (MotorState.FwdState && MotorState.RevState)
                                {
                                    //Is braked (hi)
                                    controller.Write(pinRev, PinValue.Low);
                                    Console.WriteLine("    Pin: {0} State: {1}", pinRev, controller.Read(pinRev));
                                }
                                else if (!MotorState.FwdState && MotorState.RevState)
                                {
                                    //Is Rev. Brake first
                                    controller.Write(pinRev, PinValue.Low);
                                    controller.Write(pinFwd, PinValue.High);
                                    Console.WriteLine("    Pin: {0} State: {1}", pinFwd, controller.Read(pinFwd));
                                    Console.WriteLine("    Pin: {0} State: {1}", pinRev, controller.Read(pinRev));
                                }
                                else if (!MotorState.FwdState && !MotorState.RevState)
                                {
                                    //Is braked (lo)
                                    controller.Write(pinFwd, PinValue.High);
                                    Console.WriteLine("    Pin: {0} State: {1}", pinFwd, controller.Read(pinFwd));
                                }
                                else if (MotorState.FwdState && !MotorState.RevState)
                                {
                                    //Is fwd
                                }
                                if (MotorState.EnState)
                                    MsgOut = "Motor going fwd";
                                else
                                    MsgOut = "Fwd but not enabled";
                                break;
                            case 'R': // Reverse
                                if (MotorState.FwdState && MotorState.RevState)
                                {
                                    //Is braked (hi)
                                    controller.Write(pinFwd, PinValue.Low);
                                    Console.WriteLine("    Pin: {0} State: {1}", pinFwd, controller.Read(pinFwd));
                                }
                                else if (!MotorState.FwdState && MotorState.RevState)
                                {
                                    //Is reverse
                                }
                                else if (!MotorState.FwdState && !MotorState.RevState)
                                {
                                    //Is braked (lo)
                                    controller.Write(pinRev, PinValue.High);
                                    Console.WriteLine("    Pin: {0} State: {1}", pinRev, controller.Read(pinRev));
                                }
                                else if (MotorState.FwdState && !MotorState.RevState)
                                {
                                    //Is fwd: Brake first
                                    controller.Write(pinFwd, PinValue.Low);
                                    controller.Write(pinRev, PinValue.High);
                                    Console.WriteLine("    Pin: {0} State: {1}", pinFwd, controller.Read(pinFwd));
                                    Console.WriteLine("    Pin: {0} State: {1}", pinRev, controller.Read(pinRev));
                                }
                                if (MotorState.EnState)
                                    MsgOut = "Motor going rev";
                                else
                                    MsgOut = "Rev but not enabled";
                                break;
                            case 'B': //Brake
                                if (MotorState.FwdState && MotorState.RevState)
                                {
                                    //Is braked (hi)
                                }
                                else if (!MotorState.FwdState && MotorState.RevState)
                                {
                                    //Is Rev: Brake lo
                                    controller.Write(pinRev, PinValue.Low);
                                    Console.WriteLine("    Pin: {0} State: {1}", pinRev, controller.Read(pinRev));
                                }
                                else if (!MotorState.FwdState && !MotorState.RevState)
                                {
                                    //Is braked (lo)
                                }
                                else if (MotorState.FwdState && !MotorState.RevState)
                                {
                                    //Is fwd: Brake lo
                                    controller.Write(pinFwd, PinValue.Low);
                                    Console.WriteLine("    Pin: {0} State: {1}", pinFwd, controller.Read(pinFwd));
                                }
                                if (MotorState.EnState)
                                    MsgOut = "Motor is braked";
                                else
                                    MsgOut = "Braked but not enabled"; ;
                                break;
                            case 'E': //Enable
                                controller.Write(pinEn, PinValue.High);
                                Console.WriteLine("    Pin: {0} State: {1}", pinEn, controller.Read(pinEn));
                                MsgOut = "Motor Enabled";
                                break;
                            case 'D': //Disable
                                controller.Write(pinEn, PinValue.Low);
                                Console.WriteLine("    Pin: {0} State: {1}", pinEn, controller.Read(pinEn));
                                MsgOut = "Motor Disabled";
                                break;
                            case 'Q':
                                MsgOut = "Exiting";
                                ExitNow = true;
                                break;
                                //case default:
                                //    MsgOut = "Invalid command";
                                //    break;
                        }

                        MotorState.FwdState = (bool)controller.Read(pinFwd);
                        MotorState.RevState = (bool)controller.Read(pinRev);
                        MotorState.EnState = (bool)controller.Read(pinEn);
                    }
                }
                else
                {


                    exitNow = false;


                    MsgOut = "CMD NOT OK";
                    if (cmd == '\0')
                    {
                        return MsgOut;
                    }
                    else
                    {
                        string PinValueLow = "Lo";
                        string PinValueHigh = "Hi";
                        switch (char.ToUpper(cmd))
                        {
                            case '0':
                                Console.WriteLine("    pinFwd " + PinValueLow);
                                MotorState.FwdState = false;
                                MsgOut = "Fwd lo";
                                break;
                            case '1':
                                Console.WriteLine("    pinFwd " + PinValueHigh);
                                MotorState.FwdState = true;
                                MsgOut = "Fwd hi";
                                break;
                            case '2':
                                Console.WriteLine("    pinRev" + PinValueLow);
                                MotorState.RevState = false;
                                MsgOut = "Rev lo";
                                break;
                            case '3':
                                Console.WriteLine("    pinRev" + PinValueHigh);
                                MotorState.RevState = true;
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
                                if (MotorState.FwdState && MotorState.RevState)
                                {
                                    //Is braked (hi)
                                    Console.WriteLine("    pinRev " + PinValueLow);
                                    MotorState.RevState = false;
                                }
                                else if (!MotorState.FwdState && MotorState.RevState)
                                {
                                    //Is Rev. Brake first
                                    Console.WriteLine("    pinRev " + PinValueLow);
                                    Console.WriteLine("    pinFwd " + PinValueHigh);
                                    MotorState.FwdState = true;
                                    MotorState.RevState = false;
                                }
                                else if (!MotorState.FwdState && !MotorState.RevState)
                                {
                                    //Is braked (lo)
                                    Console.WriteLine("    pinFwd " + PinValueHigh);
                                    MotorState.FwdState = true;
                                }
                                else if (MotorState.FwdState && !MotorState.RevState)
                                {
                                    //Is fwd
                                }
                                if (MotorState.EnState)
                                    MsgOut = "Motor going fwd";
                                else
                                    MsgOut = "Fwd but not enabled";
                                break;
                            case 'R': // Reverse
                                if (MotorState.FwdState && MotorState.RevState)
                                {
                                    //Is braked (hi)
                                    Console.WriteLine("    pinFwd " + PinValueLow);
                                    MotorState.FwdState = false;
                                }
                                else if (!MotorState.FwdState && MotorState.RevState)
                                {
                                    //Is reverse
                                }
                                else if (!MotorState.FwdState && !MotorState.RevState)
                                {
                                    //Is braked (lo)
                                    Console.WriteLine("    pinRev " + PinValueHigh);
                                    MotorState.RevState = true;
                                }
                                else if (MotorState.FwdState && !MotorState.RevState)
                                {
                                    //Is fwd: Brake first
                                    Console.WriteLine("    pinFwd " + PinValueLow);
                                    Console.WriteLine("    pinRev " + PinValueHigh);
                                    MotorState.FwdState = false;
                                    MotorState.RevState = true;
                                }
                                if (MotorState.EnState)
                                    MsgOut = "Motor going rev";
                                else
                                    MsgOut = "Rev but not enabled";
                                break;
                            case 'B': //Brake
                                if (MotorState.FwdState && MotorState.RevState)
                                {
                                    //Is braked (hi)
                                }
                                else if (!MotorState.FwdState && MotorState.RevState)
                                {
                                    //Is Rev: Brake lo
                                    Console.WriteLine("    pinRev " + PinValueLow);
                                    MotorState.RevState = false; ;
                                }
                                else if (!MotorState.FwdState && !MotorState.RevState)
                                {
                                    //Is braked (lo)
                                }
                                else if (MotorState.FwdState && !MotorState.RevState)
                                {
                                    //Is fwd: Brake lo
                                    Console.WriteLine("    pinFwd " + PinValueLow);
                                    MotorState.FwdState = false;
                                }
                                if (MotorState.EnState)
                                    MsgOut = "Motor braked";
                                else
                                    MsgOut = "Braked but not enabled";
                                break;
                            case 'E': //Enable
                                MotorState.EnState = true;
                                Console.WriteLine("    pinEn " + PinValueHigh);
                                MsgOut = "Motor enabled";
                                break;
                            case 'D': //Disable
                                MotorState.EnState = false;
                                Console.WriteLine("    pinEn " + PinValueLow);
                                MsgOut = "Motor disabled";
                                break;
                            case 'Q':
                                MsgOut = "Exiting";
                                ExitNow = true;
                                break;
                                //case default:
                                //    MsgOut = "Invalid command";
                                //    break;
                        }
                    }
                }
            }
            Console.WriteLine($"        Device: {MsgOut}");
            Console.WriteLine();
            return MsgOut;
        }
    }
}
