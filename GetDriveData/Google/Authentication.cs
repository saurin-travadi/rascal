using System;
using System.IO;
using System.Security.Cryptography.X509Certificates;
using Google.Apis.Drive.v2;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Services;

namespace IAAI.GoogleDocs.Google
{
    public class Authentication
    {
        /// <summary>
        /// Authenticating to Google using a Service account
        /// Documentation: https://developers.google.com/accounts/docs/OAuth2#serviceaccount
        /// </summary>
        /// <param name="serviceAccountEmail">From Google Developer console https://console.developers.google.com</param>
        /// <param name="keyFilePath">Location of the Service account key file downloaded from Google Developer console https://console.developers.google.com</param>
        /// <returns>Authenticated Analytics Service</returns>
        public static DriveService AuthenticateServiceAccount(string serviceAccountEmail, string keyFilePath)
        {

            // check the file exists
            if (!File.Exists(keyFilePath))
            {
                Console.WriteLine("An Error occurred - Key file does not exist");
                return null;
            }

            var scopes = new string[]
            {
                DriveService.Scope.Drive,
                DriveService.Scope.DriveReadonly,
                DriveService.Scope.DriveAppdata,
                DriveService.Scope.DriveAppsReadonly,
                DriveService.Scope.DriveFile,
                DriveService.Scope.DriveMetadataReadonly,
                DriveService.Scope.DriveScripts
            
            }; 

            var certificate = new X509Certificate2(keyFilePath, "notasecret", X509KeyStorageFlags.Exportable);
            try
            {

                var credential = new ServiceAccountCredential(
                    new ServiceAccountCredential.Initializer(serviceAccountEmail)
                    {
                        //User = serviceAccountEmail,
                        Scopes = scopes
                    }.FromCertificate(certificate));


                // Create the service.
                var service = new DriveService(new BaseClientService.Initializer()
                {
                    HttpClientInitializer = credential,
                    ApplicationName = "Google Docs Api"
                });
                return service;

                

            }
            catch (Exception ex)
            {
                return null;
            }
        }

    }
}
