using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MyVINService
{
    public partial class DataDownload : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var user = Request.QueryString["user"] ?? "";

            var dataSet = clsDB.funcExecuteSQLDS(string.Format("usp_Recall_API_UserStatByDate '{0}'",user), ConfigurationManager.ConnectionStrings["Connection"].ConnectionString);
            if (dataSet != null && dataSet.Tables.Count > 0 && dataSet.Tables[0].Rows.Count > 0)
            {
                var sb = new StringBuilder();
                string heading = "Date,Count";
                if (user == "") heading = "User," + heading;
                sb.AppendLine(heading);

                dataSet.Tables[0].Rows.OfType<DataRow>().ToList().ForEach(row =>
                {
                    var csv = Convert.ToDateTime(row["DataCollectionOn"]).ToString("MM-dd-yyyy") + "," + row["Cnt"].ToString();
                    if (user == "") csv = row["UserName"].ToString() + "," + csv;

                    sb.AppendLine(csv);
                });

                Response.Clear();
                Response.Buffer = true;
                Response.AddHeader("content-disposition", "attachment; filename=" + System.DateTime.Now.ToShortDateString() + ".csv");
                Response.Charset = "";
                Response.ContentType = "text/csv"; ;

                Response.Write(sb.ToString());
                Response.End();
            }
            else
            {
                Response.Write("Unable to download production stat");
            }
        }
    }
}