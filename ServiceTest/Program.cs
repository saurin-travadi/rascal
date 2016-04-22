using System;
using System.Data;

namespace GetDriveTest
{
    class Program
    {
        static void Main(string[] args)
        {
            new Service.GetCampaignData().ReadCampaignFile();

        }

        //static void ReadCampaign()
        //{
        //    var file = new TabDelimited.DownloadTabDelimited();
        //    file.DownloadZipFromRemoteURL("http://www-odi.nhtsa.dot.gov/downloads/folders/Recalls/FLAT_RCL.zip", AppDomain.CurrentDomain.BaseDirectory);

        //    var dataSet = new DataSet();
        //    var dataTable = new DataTable();
        //    dataTable.Columns.Add("RECORD_ID");
        //    dataTable.Columns.Add("CAMPNO");
        //    dataTable.Columns.Add("MAKETXT");
        //    dataTable.Columns.Add("MODELTXT");
        //    dataTable.Columns.Add("YEARTXT");
        //    dataTable.Columns.Add("MFGCAMPNO");
        //    dataTable.Columns.Add("COMPNAME");
        //    dataTable.Columns.Add("MFGNAME");
        //    dataTable.Columns.Add("BGMAN");
        //    dataTable.Columns.Add("ENDMAN");
        //    dataTable.Columns.Add("RCLTYPECD");
        //    dataTable.Columns.Add("POTAFF");
        //    dataTable.Columns.Add("ODATE");
        //    dataTable.Columns.Add("INFLUENCED_BY");
        //    dataTable.Columns.Add("MFGTXT");
        //    dataTable.Columns.Add("RCDATE");
        //    dataTable.Columns.Add("DATEA");
        //    dataTable.Columns.Add("RPNO");
        //    dataTable.Columns.Add("FMVSS");
        //    dataTable.Columns.Add("DESC_DEFECT");
        //    dataTable.Columns.Add("CONEQUENCE_DEFECT");
        //    dataTable.Columns.Add("CORRECTIVE_ACTION");
        //    dataTable.Columns.Add("NOTES");
        //    dataTable.Columns.Add("RCL_CMPT_ID");

        //    dataSet.Tables.Add(dataTable);
        //    file.GenerateDataSet(@"D:\Projects\GitHub\rascal\ServiceTest\bin\Debug\FLAT_RCL.txt", ref dataTable);
        //}
    }
}
