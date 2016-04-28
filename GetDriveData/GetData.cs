﻿using Google.Apis.Drive.v2;
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

        public string ServiceAccountEmail { get; set; }

        public string KeyFileName { get; set; }

        public void ReadDriveFolder()
        {
            var files = GetFiles();

        }

        public string[] GetFiles()
        {
            //const string q = "mimeType = 'application/vnd.google-apps.spreadsheet'";
            //string q = "mimeType='application/vnd.google-apps.file'";
            //string q = "mimeType='application/vnd.google-apps.document'";
            string q = "mimeType='application/vnd.google-apps.unknown'";


            var service = GetService();
            List<Google.Apis.Drive.v2.Data.File> f = GoogleDriveHelper.RetrieveAllFiles(service);
            


            var files = GoogleDriveHelper.GetFiles(service, q);
            return files.ToList().ConvertAll(c => c.DownloadUrl).ToArray();
        }

        private DriveService GetService()
        {
            var service = Authentication.AuthenticateServiceAccount(ServiceAccountEmail, KeyFileName);
            return service;
        }


        private bool DownloadFile(string fileSaveAs)
        {
            const string q = "mimeType = 'application/vnd.google-apps.spreadsheet'";
            var service = GetService();
            var files = GoogleDriveHelper.GetFiles(service, q);

            if (files != null && files.Count > 0)
            {
                var file = files.FirstOrDefault(x => x.Title == fileSaveAs);
                if (file != null)
                {
                    var downloadUrl = file.ExportLinks.FirstOrDefault(x => x.Key.Equals("text/csv")).Value;
                    var success = GoogleDriveHelper.DownloadFile(service, downloadUrl, System.IO.Path.Combine(DownloadLocation, fileSaveAs));

                    return success;
                }
            }

            return false;
        }
    }

}
