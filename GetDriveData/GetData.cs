using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;

namespace GetDriveData
{
    public partial class GetData
    {
        public string DownloadLocation { get; set; }

        public void ReadDriveFolder()
        {
            //Read all the files one by one
            ReadDriveFile();
        }

        public void ReadDriveFile()
        {
            //Save to DownloadLocation
        }
    }

}
