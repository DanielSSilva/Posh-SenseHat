using System;

namespace SenseHatPowerShell
{
    class Program
    {
        public static void Main(string[] args)
        {
            Console.WriteLine(@"For some reason this has to be an app and not a classLib, otherwise
            the dll for the System.Device.Gpio.dll is not generated... 
            Created a new issue here https://github.com/dotnet/iot/issues/319");
        }
    }
}