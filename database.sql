DROP DATABASE IF EXISTS kisallat_webshop;
CREATE DATABASE kisallat_webshop CHARACTER SET utf8mb4 COLLATE utf8mb4_hungarian_ci;
USE kisallat_webshop;

CREATE TABLE felhasznalok (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    felhasznalonev  VARCHAR(50)  NOT NULL UNIQUE,
    email           VARCHAR(100) NOT NULL UNIQUE,
    jelszo_hash     VARCHAR(255) NOT NULL,
    keresztnev      VARCHAR(100),
    vezeteknev      VARCHAR(100),
    telefon         VARCHAR(30),
    iranyitoszam    VARCHAR(20),
    varos           VARCHAR(100),
    cim             TEXT,
    admin           TINYINT(1) DEFAULT 0,
    email_megerositve TINYINT(1) DEFAULT 0,
    regisztralt     TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    frissitve       TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE kategoriak (
    id          TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    slug        VARCHAR(30) NOT NULL UNIQUE,
    nev         VARCHAR(50) NOT NULL,
    kep         VARCHAR(255),
    sorrend     TINYINT DEFAULT 0
);

CREATE TABLE alkategoriak (
    id              SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    kategoria_id    TINYINT UNSIGNED NOT NULL,
    slug            VARCHAR(50) NOT NULL,
    nev             VARCHAR(100) NOT NULL,
    kep             VARCHAR(255),
    sorrend         TINYINT DEFAULT 0,
    FOREIGN KEY (kategoria_id) REFERENCES kategoriak(id) ON DELETE CASCADE,
    UNIQUE KEY egyedi_slug (kategoria_id, slug)
);

CREATE TABLE termekek (
    id              INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    alkategoria_id  SMALLINT UNSIGNED NOT NULL,
    nev             VARCHAR(255) NOT NULL,
    slug            VARCHAR(255) NOT NULL,
    leiras          TEXT,
    rovid_leiras    VARCHAR(500),
    ar              INT UNSIGNED NOT NULL,
    akcios_ar       INT UNSIGNED NULL,
    keszlet         INT UNSIGNED DEFAULT 999,
    fo_kep          VARCHAR(255) NOT NULL,
    tobbi_kep       JSON,
    aktiv           TINYINT(1) DEFAULT 1,
    letrehozva      TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    frissitve       TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (alkategoria_id) REFERENCES alkategoriak(id) ON DELETE CASCADE,
    UNIQUE KEY egyedi_slug (slug)
);

CREATE TABLE termek_velemenyek (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    termek_id       INT UNSIGNED NOT NULL,
    felhasznalo_id  BIGINT UNSIGNED NULL,
    vendeq_nev      VARCHAR(100) DEFAULT 'Névtelen vásárló',
    ertekeles       TINYINT UNSIGNED NOT NULL CHECK (ertekeles IN (1,2,3,4,5)),
    cim             VARCHAR(150) NOT NULL,
    velemeny        TEXT NOT NULL,
    segitett_igen   INT UNSIGNED DEFAULT 0,
    segitett_nem    INT UNSIGNED DEFAULT 0,
    ellenorzott     TINYINT(1) DEFAULT 0,
    elfogadva       TINYINT(1) DEFAULT 1,
    datum           TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (termek_id) REFERENCES termekek(id) ON DELETE CASCADE,
    FOREIGN KEY (felhasznalo_id) REFERENCES felhasznalok(id) ON DELETE SET NULL,
    INDEX idx_termek (termek_id),
    INDEX idx_ertekeles (ertekeles)
);

CREATE TABLE kosar (
    felhasznalo_id  BIGINT UNSIGNED NOT NULL,
    termek_id       INT UNSIGNED NOT NULL,
    PRIMARY KEY (felhasznalo_id, termek_id),
    mennyiseg       SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    hozzaadva       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (felhasznalo_id) REFERENCES felhasznalok(id) ON DELETE CASCADE,
    FOREIGN KEY (termek_id) REFERENCES termekek(id) ON DELETE CASCADE
);

CREATE TABLE rendelések (
    id                  BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    felhasznalo_id      BIGINT UNSIGNED NOT NULL,
    rendelés_szam       VARCHAR(30) NOT NULL UNIQUE,
    statusz             ENUM('új', 'feldolgozás', 'fizetve', 'kész', 'stornó') DEFAULT 'új',
    osszeg              INT UNSIGNED NOT NULL,
    szallitasi_mod      VARCHAR(100),
    fizetesi_mod        VARCHAR(100),
    megjegyzes          TEXT,
    szallitasi_nev      VARCHAR(200),
    szallitasi_cim      TEXT,
    szallitasi_varos    VARCHAR(100),
    szallitasi_irsz     VARCHAR(20),
    letrehozva          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    frissitve           TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (felhasznalo_id) REFERENCES felhasznalok(id) ON DELETE RESTRICT
);

CREATE TABLE rendeles_tetelek (
    id              BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    rendeles_id     BIGINT UNSIGNED NOT NULL,
    termek_id       INT UNSIGNED NOT NULL,
    termek_nev      VARCHAR(255) NOT NULL,
    ar              INT UNSIGNED NOT NULL,
    mennyiseg       SMALLINT UNSIGNED NOT NULL,
    FOREIGN KEY (rendeles_id) REFERENCES rendelések(id) ON DELETE CASCADE,
    FOREIGN KEY (termek_id) REFERENCES termekek(id) ON DELETE RESTRICT
);

INSERT INTO kategoriak (slug, nev, kep, sorrend) VALUES
('kutya',     'Kutya',     'img/kutya.png',     1),
('macska',    'Macska',    'img/macska.png',    2),
('ragcsalo',  'Rágcsáló',  'img/ragcsalo.png',  3),
('hullo',     'Hüllő',     'img/hullo.png',     4),
('madar',     'Madár',     'img/madar.png',     5),
('hal',       'Hal', 'img/hal.png', 6);

INSERT INTO alkategoriak (kategoria_id, slug, nev, sorrend) VALUES
(1, 'poraz',     'Pórázok', 1),
(1, 'tal',       'Tálak', 2),
(1, 'ham',       'Hámok', 3),
(1, 'bolha',     'Bolha- és kullancsírtók', 4),
(1, 'nyakorv',   'Nyakörvek', 5),
(1, 'tap',       'Tápok', 6),
(2, 'jatek',     'Játékok', 1),
(2, 'tal',       'Tálak', 2),
(2, 'ham',       'Hámok', 3),
(2, 'bolha',     'Bolhaírtó szerek', 4),
(2, 'nyakorv',   'Nyakörvek', 5),
(2, 'tapm',      'Macska tápok', 6);

INSERT INTO termek_velemenyek (termek_id, felhasznalo_id, vendeq_nev, ertekeles, cim, velemeny, ellenorzott, datum) VALUES
(1, NULL, 'Kovács Béla', 5, 'Szuper táp, a kutyám imádja!', 'A Royal Canin Mini Adult óta sokkal szebb a szőre a törpe uszkárnak, és végre nem válogatós többé. Nagyon ajánlom!', 1, '2025-01-15 14:22:33'),
(1, NULL, 'Szabó Anita', 4, 'Jó, de kicsit drága', 'Minősége kiváló, a kutyusom egészségesen tartja, de az árért több akció is elférne. Ettől függetlenül újra veszem.', 1, '2025-03-22 09:11:45'),
(3, NULL, 'Nagy István', 5, 'A legjobb hám, amit valaha vettem', 'A JULIUS-K9 erőhám piros XL tökéletesen illeskedik a németjuhászomra, végre nem húz annyira séta közben. Kötelező darab!', 1, '2025-02-28 18:47:12'),
(7, NULL, 'Kiss Eszter', 5, 'A macskám rajong érte', 'A Felix Fantastic duplán finom az egyetlen nedves táp, amit maradéktalanul megeszik a perzsa cicám. 10/10!', 1, '2025-04-10 11:30:55'),
(5, NULL, 'Tóth Gábor', 3, 'Elmegy, de van jobb is', 'A Trixie kerámia tálak szépek, de az állvány kicsit billeg. Közepes méretű kutyánál még oké, de nagyobbnál nem ajánlom.', 0, '2025-05-19 20:05:21'),
(12, NULL, 'Horváth Lili', 5, 'Végre nem vakarózik!', 'A Frontline Tri-Act után eltűntek a bolhák a spánielről, és még most, hónapok múlva sem jöttek vissza. Köszönöm!', 1, '2025-06-30 16:18:44'),
(2, NULL, 'Varga Tamás', 5, 'Ár-érték bajnok', 'Bosch Adult Menue 15 kg-os zsákot vettem, és a golden retrieverem szőre még sosem volt ilyen fényes. Profi választás!', 1, '2025-07-12 13:55:19'),
(9, NULL, 'Papp Réka', 2, 'Nem érte meg az árát', 'A KONG Kickeroo macskajátékot 2 nap alatt széttépte a maine coonom. Vártam tőle többet ennyi pénzért.', 1, '2025-08-25 10:42:33'),
(4, NULL, 'Molnár Péter', 5, 'Tökéletes póráz nagy kutyának', 'Rukka állítható kötélpóráz fekete – végre nem szakad el, és kényelmes a fogása is. 70 kg-os kaukázusi pásztorommal is bírja.', 1, '2025-09-05 19:27:58'),
(15, NULL, 'Fekete Zsanett', 5, 'A nyuszik imádják!', 'Petlife Safebed papírpehely alom a legjobb döntés volt a törpenyulaimnak. Pormentes, szagtalan, és nem eszik meg. Tökéletes!', 1, '2025-11-28 08:19:07');
