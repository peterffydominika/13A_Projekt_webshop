using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Shapes;

namespace WpfApp1
{
    /// <summary>
    /// Interaction logic for Bejelentkezes.xaml
    /// </summary>
    public partial class Bejelentkezes : Window
    {
        public Bejelentkezes()
        {
            InitializeComponent();
        }

        private void userNameTB_TextChanged(object sender, TextChangedEventArgs e)
        {
            if (userNameTB.Text == "Admin" && passwordTB.Text = "Admin12345")
            {
                
            }
        }
    }
}
