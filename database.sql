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

INSERT INTO `felhasznalok` (`id`, `felhasznalonev`, `email`, `jelszo_hash`, `keresztnev`, `vezeteknev`, `telefon`, `iranyitoszam`, `varos`, `cim`, `admin`, `email_megerositve`, `regisztralt`, `frissitve`) VALUES
(1, 'janos123', 'janos.kovacs@gmail.com', '871b32b5f4e1b9ac25237dc7e4e175954c2dc6098aade48a8abefb585cbd53f2', 'János', 'Kovács', '06 30 123 4561', '1117', 'Budapest', 'Teszt utca 1.', 0, 1, '2026-03-03 07:24:45', '2026-03-03 07:24:45'),
(2, 'anna456', 'anna.nagy@yahoo.com', '871b32b5f4e1b9ac25237dc7e4e175954c2dc6098aade48a8abefb585cbd53f2', 'Anna', 'Nagy', '06 30 123 4562', '1117', 'Budapest', 'Teszt utca 2.', 0, 1, '2026-03-03 07:24:45', '2026-03-03 07:24:45'),
(3, 'peter789', 'peter.szabo@freemail.hu', '871b32b5f4e1b9ac25237dc7e4e175954c2dc6098aade48a8abefb585cbd53f2', 'Péter', 'Szabó', '06 30 123 4563', '1117', 'Budapest', 'Teszt utca 3.', 0, 1, '2026-03-03 07:24:45', '2026-03-03 07:24:45'),
(4, 'eva101', 'eva.toth@protonmail.com', '871b32b5f4e1b9ac25237dc7e4e175954c2dc6098aade48a8abefb585cbd53f2', 'Éva', 'Tóth', '06 30 123 4564', '1117', 'Budapest', 'Teszt utca 4.', 0, 1, '2026-03-03 07:24:45', '2026-03-03 07:24:45'),
(5, 'laszlo202', 'laszlo.horvath@gmail.com', '871b32b5f4e1b9ac25237dc7e4e175954c2dc6098aade48a8abefb585cbd53f2', 'László', 'Horváth', '06 30 123 4565', '1117', 'Budapest', 'Teszt utca 5.', 0, 1, '2026-03-03 07:24:45', '2026-03-03 07:24:45');

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

INSERT INTO `alkategoriak` (`id`, `kategoria_id`, `slug`, `nev`, `kep`, `sorrend`) VALUES
(1, 1, 'poraz', 'Pórázok', NULL, 1),
(2, 1, 'tal', 'Tálak', NULL, 2),
(3, 1, 'ham', 'Hámok', NULL, 3),
(4, 1, 'bolha', 'Bolha- és kullancsírtók', NULL, 4),
(5, 1, 'nyakorv', 'Nyakörvek', NULL, 5),
(6, 1, 'tap', 'Tápok', NULL, 6),
(7, 2, 'jatek', 'Játékok', NULL, 1),
(8, 2, 'tal', 'Tálak', NULL, 2),
(9, 2, 'ham', 'Hámok', NULL, 3),
(10, 2, 'bolha', 'Bolhaírtó szerek', NULL, 4),
(11, 2, 'nyakorv', 'Nyakörvek', NULL, 5),
(12, 2, 'tapm', 'Macska tápok', NULL, 6),
(13, 3, 'horcsog', 'Hörcsög felszerelések', NULL, 1),
(14, 3, 'nyul', 'Nyúl felszerelések', NULL, 2),
(15, 3, 'tengerimalac', 'Tengerimalac felszerelések', NULL, 3),
(16, 4, 'terrarium', 'Terráriumok & kiegészítők', NULL, 1),
(17, 5, 'kalitka', 'Madárkalitkák', NULL, 1),
(18, 5, 'madar-eledel', 'Madár eledelek', NULL, 2),
(19, 5, 'madar-jatek', 'Madár játékok', NULL, 3);

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
INSERT INTO `rendelések` (`id`, `felhasznalo_id`, `rendelés_szam`, `statusz`, `osszeg`, `szallitasi_mod`, `fizetesi_mod`, `megjegyzes`, `szallitasi_nev`, `szallitasi_cim`, `szallitasi_varos`, `szallitasi_irsz`, `letrehozva`, `frissitve`) VALUES
(1, 1, 'ORD-20260204-0001', 'kész', 58158, 'GLS futár', 'Bankkártya', 'Teszt rendelés', 'János Kovács', 'Teszt utca 1', 'Budapest', '1117', '2026-03-03 07:25:11', '2026-03-03 07:25:11'),
(2, 1, 'ORD-20260204-0002', 'feldolgozás', 30991, 'GLS futár', 'Bankkártya', 'Teszt rendelés', 'János Kovács', 'Teszt utca 1', 'Budapest', '1117', '2026-03-03 07:25:11', '2026-03-03 07:25:11'),
(3, 2, 'ORD-20260204-0003', 'feldolgozás', 44579, 'GLS futár', 'Bankkártya', 'Teszt rendelés', 'Anna Nagy', 'Teszt utca 2', 'Budapest', '1117', '2026-03-03 07:25:11', '2026-03-03 07:25:11'),
(4, 2, 'ORD-20260204-0004', 'feldolgozás', 32999, 'GLS futár', 'Bankkártya', 'Teszt rendelés', 'Anna Nagy', 'Teszt utca 2', 'Budapest', '1117', '2026-03-03 07:25:11', '2026-03-03 07:25:11'),
(5, 3, 'ORD-20260204-0005', 'kész', 81025, 'GLS futár', 'Bankkártya', 'Teszt rendelés', 'Péter Szabó', 'Teszt utca 3', 'Budapest', '1117', '2026-03-03 07:25:11', '2026-03-03 07:25:11'),
(6, 3, 'ORD-20260204-0006', 'kész', 37954, 'GLS futár', 'Bankkártya', 'Teszt rendelés', 'Péter Szabó', 'Teszt utca 3', 'Budapest', '1117', '2026-03-03 07:25:11', '2026-03-03 07:25:11'),
(7, 4, 'ORD-20260204-0007', 'feldolgozás', 30961, 'GLS futár', 'Bankkártya', 'Teszt rendelés', 'Éva Tóth', 'Teszt utca 4', 'Budapest', '1117', '2026-03-03 07:25:11', '2026-03-03 07:25:11'),
(8, 4, 'ORD-20260204-0008', 'fizetve', 72711, 'GLS futár', 'Bankkártya', 'Teszt rendelés', 'Éva Tóth', 'Teszt utca 4', 'Budapest', '1117', '2026-03-03 07:25:11', '2026-03-03 07:25:11'),
(9, 5, 'ORD-20260204-0009', 'kész', 45212, 'GLS futár', 'Bankkártya', 'Teszt rendelés', 'László Horváth', 'Teszt utca 5', 'Budapest', '1117', '2026-03-03 07:25:11', '2026-03-03 07:25:11'),
(10, 5, 'ORD-20260204-0010', 'feldolgozás', 79324, 'GLS futár', 'Bankkártya', 'Teszt rendelés', 'László Horváth', 'Teszt utca 5', 'Budapest', '1117', '2026-03-03 07:25:11', '2026-03-03 07:25:11');

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

INSERT INTO `kategoriak` (`id`, `slug`, `nev`, `kep`, `sorrend`) VALUES
(1, 'kutya', 'Kutya', 'img/kutya.png', 1),
(2, 'macska', 'Macska', 'img/macska.png', 2),
(3, 'ragcsalo', 'Rágcsáló', 'img/ragcsalo.png', 3),
(4, 'hullo', 'Hüllő', 'img/hullo.png', 4),
(5, 'madar', 'Madár', 'img/madar.png', 5),
(6, 'hal', 'Hal', 'img/hal.png', 6);

INSERT INTO `termek_velemenyek` (`id`, `termek_id`, `felhasznalo_id`, `vendeq_nev`, `ertekeles`, `cim`, `velemeny`, `segitett_igen`, `segitett_nem`, `ellenorzott`, `elfogadva`, `datum`) VALUES
(11, 1, 1, 'János Kovács', 5, 'Nagyon elégedett vagyok', 'A kutyám imádja ezt a tápot, sokkal szebb lett a szőre.', 0, 0, 1, 1, '2025-12-15 09:22:00'),
(12, 1, 2, 'Anna Nagy', 4, 'Jó, de kicsit drága', 'Minőségi táp, de sajnos ritkán van akció.', 0, 0, 1, 1, '2026-01-08 13:35:00'),
(13, 10, 3, 'Péter Szabó', 5, 'A legjobb hám!', 'A német juhászomnak vettem, tökéletesen bírja a húzást.', 0, 0, 1, 1, '2025-11-20 08:15:00'),
(14, 10, 1, 'János Kovács', 5, 'Erős és kényelmes', 'Nagy kutyás gazdiknak kötelező darab!', 0, 0, 1, 1, '2026-01-22 17:45:00'),
(15, 12, 4, 'Éva Tóth', 5, 'Megmentette a kutyámat', 'Veseprobléma után ez a táp sokat segített.', 0, 0, 1, 1, '2025-10-05 09:10:00'),
(16, 3, 5, 'László Horváth', 4, 'Jó ár-érték arány', 'Puha és kényelmes, csak a szíj egy kicsit rövid.', 0, 0, 1, 1, '2026-01-12 15:50:00'),
(17, 15, 2, 'Anna Nagy', 5, 'A nyuszik imádják', 'Pormentes, szagtalan, tökéletes alom.', 0, 0, 1, 1, '2025-12-28 07:30:00'),
(18, 8, 3, 'Péter Szabó', 5, 'Nagytestű kutyámnak tökéletes', 'A 65 kg-os dogomnak vettem, nem puffad tőle.', 0, 0, 1, 1, '2026-02-01 18:20:00'),
(19, 20, 4, 'Éva Tóth', 5, 'Tágas és stabil', 'A törpenyulaim nagyon boldogok benne.', 0, 0, 1, 1, '2025-11-10 12:45:00'),
(20, 5, 1, 'János Kovács', 3, 'Elmegy, de nem tökéletes', 'A csat kicsit gyenge, hamar kikaparta a szőrt.', 0, 0, 1, 1, '2026-01-18 19:10:00'),
(21, 18, 5, 'László Horváth', 5, 'A macskám végre megeszi', 'A perzsa cicám válogatós volt, ezt minden maradék nélkül megeszi.', 0, 0, 1, 1, '2025-12-05 16:55:00'),
(22, 7, 2, 'Anna Nagy', 4, 'Idős kutyámnak jó', 'A 12 éves golden retrieverem könnyebben emészti.', 0, 0, 1, 1, '2026-01-30 10:40:00'),
(23, 16, 3, 'Péter Szabó', 5, 'Professzionális minőség', 'A szakállas agámámnak vettem, nagyon stabil.', 0, 0, 1, 1, '2025-09-25 12:15:00'),
(24, 19, 4, 'Éva Tóth', 5, 'Törpepapagájoknak tökéletes', 'Nagyon tágas, a madaraim boldogok benne.', 0, 0, 1, 1, '2026-02-03 08:05:00'),
(25, 8, 5, 'László Horváth', 5, 'Ár-érték bajnok', 'A golden retrieverem szőre még sosem volt ilyen fényes.', 0, 0, 1, 1, '2025-07-12 11:55:00');
-- Indexek a kiírt táblákhoz
--

--
-- A tábla indexei `alkategoriak`
--
ALTER TABLE `alkategoriak`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `egyedi_slug` (`kategoria_id`,`slug`);

--
-- A tábla indexei `felhasznalok`
--
ALTER TABLE `felhasznalok`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `felhasznalonev` (`felhasznalonev`),
  ADD UNIQUE KEY `email` (`email`);

--
-- A tábla indexei `kategoriak`
--
ALTER TABLE `kategoriak`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `slug` (`slug`);

--
-- A tábla indexei `kosar`
--
ALTER TABLE `kosar`
  ADD PRIMARY KEY (`felhasznalo_id`,`termek_id`),
  ADD KEY `termek_id` (`termek_id`);

--
-- A tábla indexei `rendeles_tetelek`
--
ALTER TABLE `rendeles_tetelek`
  ADD PRIMARY KEY (`id`),
  ADD KEY `rendeles_id` (`rendeles_id`),
  ADD KEY `termek_id` (`termek_id`);

--
-- A tábla indexei `rendelések`
--
ALTER TABLE `rendelések`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `rendelés_szam` (`rendelés_szam`),
  ADD KEY `felhasznalo_id` (`felhasznalo_id`);

--
-- A tábla indexei `termekek`
--
ALTER TABLE `termekek`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `egyedi_slug` (`slug`),
  ADD KEY `alkategoria_id` (`alkategoria_id`);

--
-- A tábla indexei `termek_velemenyek`
--
ALTER TABLE `termek_velemenyek`
  ADD PRIMARY KEY (`id`),
  ADD KEY `felhasznalo_id` (`felhasznalo_id`),
  ADD KEY `idx_termek` (`termek_id`),
  ADD KEY `idx_ertekeles` (`ertekeles`);

--
-- A kiírt táblák AUTO_INCREMENT értéke
--

--
-- AUTO_INCREMENT a táblához `alkategoriak`
--
ALTER TABLE `alkategoriak`
  MODIFY `id` smallint(5) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT a táblához `felhasznalok`
--
ALTER TABLE `felhasznalok`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT a táblához `kategoriak`
--
ALTER TABLE `kategoriak`
  MODIFY `id` tinyint(3) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT a táblához `rendeles_tetelek`
--
ALTER TABLE `rendeles_tetelek`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT a táblához `rendelések`
--
ALTER TABLE `rendelések`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT a táblához `termekek`
--
ALTER TABLE `termekek`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT a táblához `termek_velemenyek`
--
ALTER TABLE `termek_velemenyek`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- Megkötések a kiírt táblákhoz
--

--
-- Megkötések a táblához `alkategoriak`
--
ALTER TABLE `alkategoriak`
  ADD CONSTRAINT `alkategoriak_ibfk_1` FOREIGN KEY (`kategoria_id`) REFERENCES `kategoriak` (`id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `kosar`
--
ALTER TABLE `kosar`
  ADD CONSTRAINT `kosar_ibfk_1` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `kosar_ibfk_2` FOREIGN KEY (`termek_id`) REFERENCES `termekek` (`id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `rendeles_tetelek`
--
ALTER TABLE `rendeles_tetelek`
  ADD CONSTRAINT `rendeles_tetelek_ibfk_1` FOREIGN KEY (`rendeles_id`) REFERENCES `rendelések` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `rendeles_tetelek_ibfk_2` FOREIGN KEY (`termek_id`) REFERENCES `termekek` (`id`);

--
-- Megkötések a táblához `rendelések`
--
ALTER TABLE `rendelések`
  ADD CONSTRAINT `rendelések_ibfk_1` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`id`);

--
-- Megkötések a táblához `termekek`
--
ALTER TABLE `termekek`
  ADD CONSTRAINT `termekek_ibfk_1` FOREIGN KEY (`alkategoria_id`) REFERENCES `alkategoriak` (`id`) ON DELETE CASCADE;

--
-- Megkötések a táblához `termek_velemenyek`
--
ALTER TABLE `termek_velemenyek`
  ADD CONSTRAINT `termek_velemenyek_ibfk_1` FOREIGN KEY (`termek_id`) REFERENCES `termekek` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `termek_velemenyek_ibfk_2` FOREIGN KEY (`felhasznalo_id`) REFERENCES `felhasznalok` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
