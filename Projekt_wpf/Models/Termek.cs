using System;

namespace NyilvantartoApp.Models
{
    public class Termek
    {
        public Termek(int id, int alkategoria_id, string nev, int ar, int akcios_ar, int keszlet)
        {
            Id = id;
            Alkategoria_id = alkategoria_id;
            Nev = nev;
            Ar = ar;
            Akcios_ar = akcios_ar;
            Keszlet = keszlet;
        }

        public int Id { get; set; } // Changed to public set for post-insert update
        public int Alkategoria_id { get; set; } // Changed to public set for post-insert update
        public string Nev { get; set; }
        public int Ar { get; set; }
        public int Akcios_ar { get; set; }
        public int Keszlet { get; set; }
    }
}