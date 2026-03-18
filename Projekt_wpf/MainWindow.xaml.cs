using MySql.Data.MySqlClient;
using NyilvantartoApp.Models;
using System;
using System.Collections.ObjectModel;
using System.Data;
using System.Windows;
using System.Windows.Controls;

namespace Projekt_wpf
{
    public partial class MainWindow : Window
    {
        public static ObservableCollection<Termek> Nyilvantartas { get; } = new ObservableCollection<Termek>();
        private static List<int> DeletedIds { get; } = new List<int>();
        private int selectedIndex = -1;

        private string connectionString = "Server=s61.tarhely.com;Database=kisalla9_webshop;Uid=kisalla9_user;Pwd=Webshop123.;";

        public MainWindow()
        {
            InitializeComponent();
            dtgAdatok.ItemsSource = Nyilvantartas;
        }

        private void btnBetolt_Click(object sender, RoutedEventArgs e)
        {
            LoadDataToGrid();
        }

        private void LoadDataToGrid()
        {
            string query = "SELECT id, alkategoria_id, nev, ar, akcios_ar, keszlet FROM termekek";

            try
            {
                using (MySqlConnection connection = new MySqlConnection(connectionString))
                {
                    connection.Open();
                    using (MySqlDataAdapter adapter = new MySqlDataAdapter(query, connection))
                    {
                        DataTable dataTable = new DataTable();
                        adapter.Fill(dataTable);

                        Nyilvantartas.Clear();
                        foreach (DataRow row in dataTable.Rows)
                        {
                            Nyilvantartas.Add(new Termek(
                                Convert.ToInt32(row["id"]),  // id nem lehet NULL
                                Convert.ToInt32(row["alkategoria_id"]),  // id nem lehet NULL
                                row["nev"].ToString() ?? "",  // NULL esetén üres string
                                row["ar"] == DBNull.Value ? 0 : Convert.ToInt32(row["ar"]),
                                row["akcios_ar"] == DBNull.Value ? 0 : Convert.ToInt32(row["akcios_ar"]),  // Vagy row["ar"] értékét használd, ha logikus
                                row["keszlet"] == DBNull.Value ? 0 : Convert.ToInt32(row["keszlet"])
                            ));
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hiba a betöltésnél: " + ex.Message);
            }
        }

        public static void TermekFelvitel(Termek ujTermek)
        {
            Nyilvantartas.Add(ujTermek);
        }

        public void TermekModositas(Termek modositottTermek)
        {
            if (selectedIndex >= 0 && selectedIndex < Nyilvantartas.Count)
            {
                Nyilvantartas[selectedIndex] = modositottTermek;
            }
        }

        private void btnKilep_Click(object sender, RoutedEventArgs e)
        {
            Application.Current.Shutdown();
        }

        private void btnNevjegy_Click(object sender, RoutedEventArgs e)
        {
            Nevjegy nevjegy = new Nevjegy();
            nevjegy.Show();
        }

        private void dtgAdatok_SelectionChanged(object sender, SelectionChangedEventArgs e)
        {
            if (dtgAdatok.SelectedItem is Termek selectedTermek)
            {
                selectedIndex = Nyilvantartas.IndexOf(selectedTermek);
            }
        }

        private void btnFelvisz_Click(object sender, RoutedEventArgs e)
        {
            new Modositas(new Termek(0, 0, "", 0, 0, 0), "Add", this).ShowDialog();
        }

        private void btnModosit_Click(object sender, RoutedEventArgs e)
        {
            if (selectedIndex >= 0)
            {
                var selectedTermek = Nyilvantartas[selectedIndex];
                new Modositas(selectedTermek, "Modify", this).ShowDialog();
            }
            else
            {
                MessageBox.Show("Válasszon ki egy terméket a módosításhoz!");
            }
        }

        private void btnTorol_Click(object sender, RoutedEventArgs e)
        {
            if (selectedIndex >= 0)
            {
                var termek = Nyilvantartas[selectedIndex];
                if (termek.Id != 0)
                {
                    DeletedIds.Add(termek.Id);
                }
                Nyilvantartas.RemoveAt(selectedIndex);
                selectedIndex = -1;
            }
            else
            {
                MessageBox.Show("Válasszon ki egy terméket a törléshez!");
            }
        }

        private void btnMent_Click(object sender, RoutedEventArgs e)
        {
            try
            {
                using (MySqlConnection connection = new MySqlConnection(connectionString))
                {
                    connection.Open();

                    // Handle deletes
                    foreach (var id in DeletedIds)
                    {
                        string deleteQuery = "DELETE FROM termekek WHERE id = @id";
                        using (MySqlCommand cmd = new MySqlCommand(deleteQuery, connection))
                        {
                            cmd.Parameters.AddWithValue("@id", id);
                            cmd.ExecuteNonQuery();
                        }
                    }
                    DeletedIds.Clear();

                    // Handle inserts and updates
                    foreach (var termek in Nyilvantartas)
                    {
                        if (termek.Id == 0)
                        { // New product
                            string insertQuery = "INSERT INTO termekek (alkategoria_id, nev, ar, akcios_ar, keszlet) VALUES (@alkategoria_id, @nev, @ar, @akcios_ar, @keszlet)";
                            using (MySqlCommand cmd = new MySqlCommand(insertQuery, connection))
                            {
                                cmd.Parameters.AddWithValue("@alkategoria_id", termek.Alkategoria_id);
                                cmd.Parameters.AddWithValue("@nev", termek.Nev);
                                cmd.Parameters.AddWithValue("@ar", termek.Ar);
                                cmd.Parameters.AddWithValue("@akcios_ar", termek.Akcios_ar);
                                cmd.Parameters.AddWithValue("@keszlet", termek.Keszlet);
                                cmd.ExecuteNonQuery();

                                cmd.CommandText = "SELECT LAST_INSERT_ID()";
                                termek.Id = Convert.ToInt32(cmd.ExecuteScalar());
                            }
                        }
                        else
                        { // Update
                            string updateQuery = "UPDATE termekek SET alkategoria_id = @alkategoria_id, nev = @nev, ar = @ar, akcios_ar = @akcios_ar, keszlet = @keszlet WHERE id = @id";
                            using (MySqlCommand cmd = new MySqlCommand(updateQuery, connection))
                            {
                                cmd.Parameters.AddWithValue("@id", termek.Id);
                                cmd.Parameters.AddWithValue("@alkategoria_id", termek.Alkategoria_id);
                                cmd.Parameters.AddWithValue("@nev", termek.Nev);
                                cmd.Parameters.AddWithValue("@ar", termek.Ar);
                                cmd.Parameters.AddWithValue("@akcios_ar", termek.Akcios_ar);
                                cmd.Parameters.AddWithValue("@keszlet", termek.Keszlet);
                                cmd.ExecuteNonQuery();
                            }
                        }
                    }
                }
                MessageBox.Show("Változások sikeresen mentve az adatbázisba!");
                LoadDataToGrid(); // Refresh grid
            }
            catch (Exception ex)
            {
                MessageBox.Show("Hiba a mentésnél: " + ex.Message);
            }
        }
    }
}
