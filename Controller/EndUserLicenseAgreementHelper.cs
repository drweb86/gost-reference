using System;
using System.Globalization;
using System.IO;
using System.Windows;

namespace GostReferences.Controller
{
    static class EndUserLicenseAgreementHelper
    {
        public static void EnsureUserAgreedOnLicense()
        {
            if (NotUserAgreed())
            {
                if (ShowAgreement())
                {
                    SaveUserAgreed();
                }
                else
                {
                    ExitApplication();
                }
            }
        }

        private static void ExitApplication()
        {
            Environment.Exit(-1);
        }

        private static bool ShowAgreement()
        {
            return MessageBox.Show(LoadText(), "Лицензионное соглашение - Оформление ссылок по ГОСТ",
                MessageBoxButton.YesNo, MessageBoxImage.Question) == MessageBoxResult.Yes;
        }

        private static string LoadText()
        {
            using (var stream = Application.GetResourceStream(new Uri("pack://application:,,,/License.txt", UriKind.Absolute)).Stream)
            using (var reader = new StreamReader(stream))
                return reader.ReadToEnd();
        }

        private static void SaveUserAgreed()
        {
            var file = GetUserLicenseAgreedFile();
            var directory = Path.GetDirectoryName(file);

            if (!Directory.Exists(directory))
                Directory.CreateDirectory(directory);

            if (!File.Exists(file))
                File.WriteAllText(file, DateTime.UtcNow.ToString(CultureInfo.InvariantCulture));
        }

        private static bool NotUserAgreed()
        {
            return !File.Exists(GetUserLicenseAgreedFile());
        }

        private static string GetUserLicenseAgreedFile()
        {
            return Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.ApplicationData),
                "HDE",
                "GostReferences",
                "UserLicenseAgreed.txt");
        }
    }
}
