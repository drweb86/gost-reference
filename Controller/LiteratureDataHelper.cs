using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Windows;
using System.Xml.Serialization;
using GostReferences.Model;

namespace GostReferences.Controller
{
    static class LiteratureDataHelper
    {
        #region Public Methods

        public static LiteratureData Load()
        {
            var result = LoadData();
            VerifyData(result);

            return result;
        }

        #endregion

        #region Private Methods

        private static void VerifyData(LiteratureData literatureData)
        {
            if (literatureData.LiteratureSamples == null)
                throw new DataException("LiteratureSamples is null.");

            foreach (var literatureSample in literatureData.LiteratureSamples)
            {
                if (string.IsNullOrWhiteSpace(literatureSample.Title))
                    throw new DataException("'Title' node is empty or missing.");

                if (literatureSample.Samples == null)
                    throw new DataException(string.Format("{0}: 'Samples' node is empty or missing.", literatureSample.Title));

                if (literatureSample.Samples.Count == 0)
                    throw new DataException(string.Format("{0}: 'Samples' does not contain samples.", literatureSample.Title));
            }
        }

        private static LiteratureData LoadData()
        {
            using (Stream stream = Application.GetResourceStream(new Uri("pack://application:,,,/Data.xml", UriKind.Absolute)).Stream)
            {
                return (LiteratureData)new XmlSerializer(typeof(LiteratureData)).Deserialize(stream);
            }
        }

        #endregion
    }
}
