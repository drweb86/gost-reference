using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Windows.Documents;
using System.Windows.Navigation;

namespace GostReferences.View
{
    public class ExternalBrowserHyperlink : Hyperlink
    {
        public ExternalBrowserHyperlink()
        {
            RequestNavigate += OnRequestNavigate;
        }

        private void OnRequestNavigate(object sender, RequestNavigateEventArgs e)
        {
            Process.Start(new ProcessStartInfo(e.Uri.AbsoluteUri));
            e.Handled = true;
        }
    }
}
