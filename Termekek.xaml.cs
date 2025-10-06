using System;
using System.Collections.ObjectModel;
using System.Windows;

namespace WpfApp1
{
    public partial class MainWindow : Window
    {
        private ObservableCollection<Termek> termekek;  // Globális változó a gyűjteményhez
        private Random random = new Random();  // Random a generáláshoz

        public MainWindow()
        {
            InitializeComponent();

            // Inicializáld a gyűjteményt
            termekek = new ObservableCollection<Termek>();

            // Generáljunk 10 random terméket induláskor (mint korábban)
            for (int i = 1; i <= 10; i++)
            {
                Termek ujTermek = new Termek
                {
                    Id = i,
                    Nev = "Termék" + random.Next(1, 1001),
                    Mennyiseg = random.Next(1, 101),
                    Egysegar = Math.Round(random.NextDouble() * 450 + 50, 2)
                };
                termekek.Add(ujTermek);
            }

            // Kösd az adatokat
            dataGrid.ItemsSource = termekek;
        }

        private void Button_UjTermekBeszurasa(object sender, RoutedEventArgs e)
        {
            // Új random termék létrehozása
            Termek ujTermek = new Termek
            {
                Id = termekek.Count + 1,  // Következő ID
                Nev = "Új Termék" + random.Next(1, 1001),
                Mennyiseg = random.Next(1, 101),
                Egysegar = Math.Round(random.NextDouble() * 450 + 50, 2)
            };

            // Beszúrás a gyűjteménybe (pl. a végére)
            termekek.Add(ujTermek);

            // Opcionális: Görgess az új sorhoz
            dataGrid.ScrollIntoView(ujTermek);
        }

        private void DataGrid_SelectionChanged(object sender, System.Windows.Controls.SelectionChangedEventArgs e)
        {
            // Itt kezeld a kijelölést, ha szükséges
        }
    }
}