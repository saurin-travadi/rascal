using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;

namespace MyVINService
{
    public class GetVIN : IHttpHandler
    {
        static int CurrentCounter;

        public bool IsReusable
        {
            get
            {
                return true;
            }
        }

        public void ProcessRequest(HttpContext context)
        {
            context.Response.AddHeader("Content-Type", "application/json\n\n");
            context.Response.Buffer = true;

            var scriptFile = Path.Combine(context.Server.MapPath("."), "vinscript.rjs");
            var data = File.ReadAllText(scriptFile);
            var vins = File.ReadLines(Path.Combine(context.Server.MapPath("."), "vin.csv")).ToArray();
            context.Response.Write(JsonConvert.SerializeObject(new VINResponse() { VIN = vins[CurrentCounter++], TotalRemining = 20, TotalReserved = 40 }));
            context.Response.Flush();
        }

        public void Process(HttpContext context)
        {
            context.Response.AddHeader("Content-Type", "application/json\n\n");
            context.Response.Buffer = true;

            var scriptFile = Path.Combine(context.Server.MapPath("."), "vinscript.rjs");
            var data = File.ReadAllText(scriptFile);

            var vins = File.ReadLines(Path.Combine(context.Server.MapPath("."), "vin.csv")).ToArray();
            if (CurrentCounter >= vins.Length) CurrentCounter = 0;

            data = data.Replace("%VIN%", vins[CurrentCounter++]);

            context.Response.Write(data);
            context.Response.Flush();
        }

        public VINResponse ProcessVIN(string userName, string VIN, string data)
        {
            var vins = File.ReadLines(Path.Combine(HttpContext.Current.Server.MapPath("."), "vin.csv")).ToArray();
            if (CurrentCounter >= vins.Length) CurrentCounter = 0;

            return new VINResponse() { VIN = vins[CurrentCounter++], TotalReserved = 147, TotalRemining = 147 - CurrentCounter };
        }
    }

    public class VINResponse
    {
        public string VIN { get; set; }
        public int TotalReserved { get; set; }
        public int TotalRemining { get; set; }
    }
}