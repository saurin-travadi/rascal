using System;
using System.Configuration;
using System.Data.SqlClient;
using System.IO;

namespace Service
{
    public class GetServiceData
    {
        public void ReadCampaignFile()
        {
            var connection = ConfigurationManager.ConnectionStrings["Connection"].ConnectionString;
            var downloadFolder = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, ConfigurationManager.AppSettings["Download_Campaign_Folder"]);
            if (!Directory.Exists(downloadFolder))
                Directory.CreateDirectory(downloadFolder);

            var dataSet = clsDB.funcExecuteSQLDS("usp_Recall_WS_GetCamapaign", connection);
            var file = new TabDelimited.DownloadTabDelimited();
            file.DownloadZipFromRemoteURL("http://www-odi.nhtsa.dot.gov/downloads/folders/Recalls/FLAT_RCL.zip", downloadFolder);

            var dataTable = dataSet.Tables[0];
            file.GenerateDataSet(@"D:\Projects\GitHub\rascal\ServiceTest\bin\Debug\FLAT_RCL.txt", ref dataTable);

            clsDB.funcExecuteSQL("usp_Recall_WS_TruncateCampaign", connection);
            using (SqlBulkCopy bulkCopy = new SqlBulkCopy(connection))
            {
                var tableName = "Recall_Campaign";
                bulkCopy.DestinationTableName = tableName;
                bulkCopy.BulkCopyTimeout = 600;
                bulkCopy.WriteToServer(dataTable);
            }
        }

        public void ReadVINFromDrive()
        {
            var google_ClientId = ConfigurationManager.AppSettings["Google_ClientId"];
            var google_Secret = ConfigurationManager.AppSettings["Google_Secret"];
            var google_UserName = ConfigurationManager.AppSettings["Google_UserName"];

            var downloadFolder = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, ConfigurationManager.AppSettings["Download_Drive_Folder"]);
            if (!Directory.Exists(downloadFolder))
                Directory.CreateDirectory(downloadFolder);

            var res = new GetDriveData.GetData() { DownloadLocation=downloadFolder, GoogleClientId=google_ClientId, GoogleClientSecret=google_Secret, GoogleUserName=google_UserName }.ReadDriveFolderForFiles();

        }

    }
}
