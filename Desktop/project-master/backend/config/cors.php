<?php
/**
 * CORS beállítások - Apache .htaccess kezeli a headereket
 * Ez a fájl csak a preflight OPTIONS kezelésére szolgál PHP szinten
 */

header("Content-Type: application/json; charset=UTF-8");

// Preflight request kezelése
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}
