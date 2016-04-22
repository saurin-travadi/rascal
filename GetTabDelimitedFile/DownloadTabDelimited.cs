using ICSharpCode.SharpZipLib.Core;
using ICSharpCode.SharpZipLib.Zip;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Net;

namespace TabDelimited
{
    public class DownloadTabDelimited
    {
        public bool DownloadZipFromRemoteURL(string url, string extractToFolder)
        {
            var downloadFile = Path.Combine(extractToFolder, string.Format("{0}.zip", DateTime.Now.ToString("MMddyyyyhhmmss")));
            var webClient = new WebClient();

            //for history purpose
            webClient.DownloadFile(url, downloadFile);

            Stream data = webClient.OpenRead(url);
            if (UnzipFromStream(data, extractToFolder))
            {
                return true;
            }

            return false;
        }

        public bool UnzipFromStream(Stream zipStream, string outFolder)
        {
            try
            {
                ZipInputStream zipInputStream = new ZipInputStream(zipStream);
                ZipEntry zipEntry = zipInputStream.GetNextEntry();
                while (zipEntry != null)
                {
                    String entryFileName = zipEntry.Name;
                    // to remove the folder from the entry:- entryFileName = Path.GetFileName(entryFileName);
                    // Optionally match entrynames against a selection list here to skip as desired.
                    // The unpacked length is available in the zipEntry.Size property.

                    byte[] buffer = new byte[4096];     // 4K is optimum

                    // Manipulate the output filename here as desired.
                    String fullZipToPath = Path.Combine(outFolder, entryFileName);
                    string directoryName = Path.GetDirectoryName(fullZipToPath);
                    if (directoryName.Length > 0)
                        Directory.CreateDirectory(directoryName);

                    // Unzip file in buffered chunks. This is just as fast as unpacking to a buffer the full size
                    // of the file, but does not waste memory.
                    // The "using" will close the stream even if an exception occurs.
                    using (FileStream streamWriter = File.Create(fullZipToPath))
                    {
                        StreamUtils.Copy(zipInputStream, streamWriter, buffer);
                    }
                    zipEntry = zipInputStream.GetNextEntry();
                }
                return true;
            }
            catch
            {
                return false;
            }
        }

        public bool GenerateDataSet(string fullFileName, ref DataTable dataTable)
        {
            var sepList = new List<string>();

            // Read the file and display it line by line.
            using (var file = new StreamReader(fullFileName))
            {
                string line;
                while ((line = file.ReadLine()) != null)
                {
                    var delimiters = new char[] { '\t' };
                    var segments = line.Split(delimiters);

                    var dr = dataTable.NewRow();
                    for (int col = 0; col < dataTable.Columns.Count; col++)
                    {
                        dr[col] = segments[col].Trim();
                    }
                    dataTable.Rows.Add(dr);
                }

                file.Close();
            }
            return true;
        }

    }
}
