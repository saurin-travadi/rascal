using Google.Apis.Drive.v2;
using IAAI.GoogleDocs.Google;
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
        public string GoogleClientId { get; set; }
        public string GoogleClientSecret { get; set; }
        public string GoogleUserName { get; set; }

        public string[] ReadDriveFolderForFiles(string folder = "In")
        {
            DriveService service = Authentication.AuthenticateOauth(GoogleClientId, GoogleClientSecret, GoogleUserName);
            string q = "title = '" + folder + "' and mimeType = 'application/vnd.google-apps.folder'";
            var dir = GoogleDriveHelper.GetFiles(service, q);
            if (dir == null || dir.Count == 0)
                return null;

            q = "'" + dir[0].Id + "' in parents";
            var _filesInsideDir = GoogleDriveHelper.GetFiles(service, q);
            var retList = new List<string>();
            foreach (var f in _filesInsideDir)
            {
                string downloadedFile = Path.Combine(DownloadLocation, f.OriginalFilename);
                GoogleDriveHelper.downloadFile(service, f.DownloadUrl, downloadedFile);

                if (System.IO.File.Exists(downloadedFile))
                {
                    retList.Add(downloadedFile);
                    GoogleDriveHelper.removeFileFromFolder(service, dir[0].Id, f.Id);
                }
            }

            return retList.ToArray();
        }

    }

}
