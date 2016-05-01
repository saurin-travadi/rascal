using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Web;

namespace MyVINService
{
    public class GetVIN : IHttpHandler
    {
        public bool IsReusable
        {
            get
            {
                return true;
            }
        }

        private UserRequest UserRequest { get; set; }
        public void ProcessRequest(HttpContext context)
        {
            context.Response.AddHeader("Content-Type", "application/json\n\n");
            context.Response.Buffer = true;

            if (!string.IsNullOrEmpty(context.Request.Params["user"]))
            {
                UserRequest = new UserRequest();
                UserRequest.User = context.Request.Params["user"];
                if (!string.IsNullOrEmpty(context.Request.Params["vin"]))
                    UserRequest.VIN = context.Request.Params["vin"];

                if (!string.IsNullOrEmpty(context.Request.Params["data"]))
                    UserRequest.Data = context.Request.Params["data"];

                if (!string.IsNullOrEmpty(context.Request.Params["error"]))
                    UserRequest.ErrorOut = Convert.ToInt16(context.Request.Params["error"]);

                var res = ProcessVIN();
                context.Response.Write(JsonConvert.SerializeObject(res));
                context.Response.Flush();
            }
        }

        private VINResponse ProcessVIN()
        {
            var dataSet = clsDB.funcExecuteSQLDS(string.Format("usp_Recall_API_Process_Vin @User='{0}',@VIN='{1}',@Data='{2}', @Error={3}", UserRequest.User, UserRequest.VIN, UserRequest.Data, UserRequest.ErrorOut), ConfigurationManager.ConnectionStrings["Connection"].ConnectionString);
            if (dataSet != null && dataSet.Tables.Count > 0 && dataSet.Tables[0].Rows.Count > 0)
            {
                var dr = dataSet.Tables[0].Rows[0];
                return new VINResponse() { VIN = dr["VIN"].ToString(), TotalRemining = dr["TotalRemaining"].ToString(), TotalReserved = dr["TotalReserved"].ToString(), Rate= dr["Rate"].ToString() };
            }
            else
            {
                return new VINResponse();
            }
        }
    }

    public class UserRequest
    {
        public string User { get; set; }
        public string VIN { get; set; }
        public string Data { get; set; }
        public int ErrorOut { get; set; }
    }

    public class VINResponse
    {
        public string VIN { get; set; }
        public string TotalReserved { get; set; }
        public string TotalRemining { get; set; }
        public string Rate { get; set; }
    }
}