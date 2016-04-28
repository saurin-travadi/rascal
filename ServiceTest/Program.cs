using System;
using System.Data;

namespace GetDriveTest
{
    class Program
    {
        static void Main(string[] args)
        {
            //new Service.GetServiceData().ReadCampaignFile();

            new Service.GetServiceData().ReadVINFromDrive();
            


        }
        
    }
}
