using NyilvantartoApp.Models;
using System;
using System.Windows;
using System.Windows.Controls;

namespace Projekt_wpf
{
    public partial class Modositas : Window
    {
        private string command;
        private MainWindow caller;

        public Modositas(Termek termek, string command, MainWindow caller)
        {
            InitializeComponent();
            tbxId.Text = termek.Id.ToString();
            tbxAlkategoriaId.Text = termek.Alkategoria_id.ToString();
            tbxNev.Text = termek.Nev;
            tbxAr.Text = termek.Ar.ToString();
            tbxAkciosAr.Text = termek.Akcios_ar.ToString();
            tbxKeszlet.Text = termek.Keszlet.ToString();
            this.command = command;
            this.caller = caller;
        }

        private void btnOk_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                int id = int.Parse(tbxId.Text);
                int alkategoria_id = int.Parse(tbxAlkategoriaId.Text);
                string nev = tbxNev.Text;
                int ar = int.Parse(tbxAr.Text);
                int akciosAr = int.Parse(tbxAkciosAr.Text);
                int keszlet = int.Parse(tbxKeszlet.Text);

                var newTermek = new Termek(id, alkategoria_id, nev, ar, akciosAr, keszlet);

                if (command == "Modify")
                {
                    caller.TermekModositas(newTermek);
                }
                else
                {
                    MainWindow.TermekFelvitel(newTermek);
                }
                Close();
            }
            catch (FormatException)
            {
                MessageBox.Show("Érvénytelen input: Az áraknak és készletnek számnak kell lennie!");
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hiba: " + ex.Message);
            }
        }
    }
}