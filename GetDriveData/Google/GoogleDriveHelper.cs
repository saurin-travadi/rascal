using System;
using System.Collections.Generic;
using Google.Apis.Drive.v2;
using Google.Apis.Drive.v2.Data;

namespace IAAI.GoogleDocs.Google
{
    public class GoogleDriveHelper
    {
        /// <summary>
        /// Download a file
        /// Documentation: https://developers.google.com/drive/v2/reference/files/get
        /// </summary>
        /// <param name="service">a Valid authenticated DriveService</param>
        /// <param name="downloadUrl">Download Url</param>
        /// <param name="saveTo">location of where to save the file including the file name to save it as.</param>
        /// <returns></returns>
        public static Boolean DownloadFile(DriveService service, string downloadUrl, string saveTo)
        {

            if (!String.IsNullOrEmpty(downloadUrl))
            {
                try
                {
                    var x = service.HttpClient.GetByteArrayAsync(downloadUrl);
                    var arrBytes = x.Result;
                    System.IO.File.WriteAllBytes(saveTo, arrBytes);
                    return true;
                }
                catch (Exception e)
                {
                    return false;
                }
            }
            // The file doesn't have any content stored on Drive.
            return false;
            
        }


        /// <summary>
        /// List all of the files and directories for the current user.  
        /// 
        /// Documentation: https://developers.google.com/drive/v2/reference/files/list
        /// Documentation Search: https://developers.google.com/drive/web/search-parameters
        /// </summary>
        /// <param name="service">a Valid authenticated DriveService</param>        
        /// <param name="search">if Search is null will return all files</param>        
        /// <returns></returns>
        public static IList<File> GetFiles(DriveService service, string search)
        {
            var files = new List<File>();
            try
            {
                //List all of the files and directories for the current user.  
                // Documentation: https://developers.google.com/drive/v2/reference/files/list
                var list = service.Files.List();
                list.MaxResults = 1000;
                if (search != null)
                {
                    list.Q = search;
                }
                var filesFeed = list.Execute();

                //// Loop through until we arrive at an empty page
                while (filesFeed.Items != null)
                {
                    // Adding each item  to the list.
                    files.AddRange(filesFeed.Items);

                    // We will know we are on the last page when the next page token is
                    // null.
                    // If this is the case, break.
                    if (filesFeed.NextPageToken == null)
                    {
                        break;
                    }

                    // Prepare the next page of results
                    list.PageToken = filesFeed.NextPageToken;

                    // Execute and process the next page request
                    filesFeed = list.Execute();
                }
            }
            catch (Exception ex)
            {

            }
            return files;
        }

        /// <summary>
        /// Download a file
        /// Documentation: https://developers.google.com/drive/v2/reference/files/get
        /// </summary>
        /// <param name="_service">a Valid authenticated DriveService</param>
        /// <param name="_fileResource">File resource of the file to download</param>
        /// <param name="_saveTo">location of where to save the file including the file name to save it as.</param>
        /// <returns></returns>
        public static Boolean downloadFile(DriveService _service, string DownloadUrl, string _saveTo)
        {

            if (!String.IsNullOrEmpty(DownloadUrl))
            {
                try
                {
                    var x = _service.HttpClient.GetByteArrayAsync(DownloadUrl);
                    byte[] arrBytes = x.Result;
                    System.IO.File.WriteAllBytes(_saveTo, arrBytes);
                    return true;
                }
                catch (Exception e)
                {
                    return false;
                }
            }
            else
            {
                // The file doesn't have any content stored on Drive.
                return false;
            }
        }

        public static void removeFileFromFolder(DriveService service, String folderId, String fileId)
        {
            service.Children.Delete(folderId, fileId).Execute();
        }


        public static List<File> RetrieveAllFiles(DriveService service)
        {
            List<File> result = new List<File>();
            FilesResource.ListRequest request = service.Files.List();

            do
            {
                try
                {
                    FileList files = request.Execute();
                    
                    result.AddRange(files.Items);
                    request.PageToken = files.NextPageToken;
                }
                catch (Exception e)
                {
                    Console.WriteLine("An error occurred: " + e.Message);
                    request.PageToken = null;
                }
            } while (!String.IsNullOrEmpty(request.PageToken));
            return result;
        }

    }
}