using System.ComponentModel;

namespace WpfApp1
{
    public class Termek : INotifyPropertyChanged
    {
        private int _id;
        private string _nev;
        private int _mennyiseg;
        private double _egysegar;

        public int Id
        {
            get { return _id; }
            set
            {
                _id = value;
                OnPropertyChanged(nameof(Id));
            }
        }

        public string Nev
        {
            get { return _nev; }
            set
            {
                _nev = value;
                OnPropertyChanged(nameof(Nev));
            }
        }

        public int Mennyiseg
        {
            get { return _mennyiseg; }
            set
            {
                _mennyiseg = value;
                OnPropertyChanged(nameof(Mennyiseg));
            }
        }

        public double Egysegar
        {
            get { return _egysegar; }
            set
            {
                _egysegar = value;
                OnPropertyChanged(nameof(Egysegar));
            }
        }

        public event PropertyChangedEventHandler PropertyChanged;

        protected void OnPropertyChanged(string propertyName)
        {
            PropertyChanged?.Invoke(this, new PropertyChangedEventArgs(propertyName));
        }
    }
}