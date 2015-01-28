using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Interop;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using GostReferences.Controller;
using GostReferences.Model;
using GostReferences.View;

namespace GostReferences
{
    /// <summary>
    /// Interaction logic for MainWindow.xaml
    /// </summary>
    public partial class MainWindow : Window, INotifyPropertyChanged
    {
        private readonly LiteratureData _data;

        #region Copy String Command

        public readonly ICommand _copyStringCommand = new CopyStringCommand();

        public ICommand CopyStringCommand
        {
            get { return _copyStringCommand; }
        }

        #endregion

        #region Literature Samples

        public CollectionViewSource LiteratureSamples { get; private set; }

        #endregion

        #region Filtering

        public bool? _filterIsIndividualWork;
        public bool? FilterIsIndividualWork
        {
            get { return _filterIsIndividualWork; }
            set
            {
                _filterIsIndividualWork = value;

                var samples = LiteratureSamples;
                if (samples != null)
                {
                    samples.View.Refresh();
                }
                OnPropertyChanged("FilterIsIndividualWork");
            }
        }

        private string _filterWordContains;
        public string FilterWordContains
        {
            get { return _filterWordContains; }
            set
            {
                _filterWordContains = value;

                var samples = LiteratureSamples;
                if (samples != null)
                {
                    samples.View.Refresh();
                }
                OnPropertyChanged("FilterWordContains");
            }
        }

        #endregion

        public MainWindow()
        {
            EndUserLicenseAgreementHelper.EnsureUserAgreedOnLicense();

            _data = LiteratureDataHelper.Load();

            LiteratureSamples = new CollectionViewSource();
            LiteratureSamples.Source = _data.LiteratureSamples;
            LiteratureSamples.Filter += FilterLiteratureSamples;
            
            FilterWordContains = string.Empty;
            FilterIsIndividualWork = null;
            
            DataContext = this;

            InitializeComponent();
        }

        private void FilterLiteratureSamples(object sender, FilterEventArgs e)
        {
            var item = (LiteratureSample)e.Item;

            var filtered = FilterIsIndividualWork;
            if (filtered != null &&
                item.IsIndependent != filtered.Value)
            {
                e.Accepted = false;
                return;
            }

            var searchText = (FilterWordContains ?? string.Empty).ToLowerInvariant();
            if (!string.IsNullOrWhiteSpace(searchText) && !item.Title.ToLowerInvariant().Contains(searchText))
            {
                e.Accepted = false;
                return;
            }

            e.Accepted = true;
        }

        public event PropertyChangedEventHandler PropertyChanged;

        public void OnPropertyChanged(string propertyName)
        {
            if (PropertyChanged != null)
            {
                PropertyChanged(this, new PropertyChangedEventArgs(propertyName));
            }
        }
    }
}
