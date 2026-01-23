<?php
/**
 * Admin API - Felhasználók kezelése
 */

require_once '../../config/database.php';
require_once '../../config/cors.php';
require_once '../../config/jwt.php';

$database = new Database();
$db = $database->getConnection();

$method = $_SERVER['REQUEST_METHOD'];

// CORS preflight
if ($method === 'OPTIONS') {
    http_response_code(204);
    exit();
}

// Admin jogosultság ellenőrzése
$admin_user = requireAdmin();

// Routing
if ($method === 'GET') {
    getAllUsers($db);
} else {
    http_response_code(405);
    echo json_encode(['message' => 'Metódus nem engedélyezett']);
}

/**
 * Összes felhasználó listázása
 */
function getAllUsers($db) {
    $query = "SELECT 
                id,
                felhasznalonev,
                email,
                keresztnev,
                vezeteknev,
                telefon,
                iranyitoszam,
                varos,
                cim,
                admin,
                email_megerositve,
                regisztralt,
                frissitve
              FROM felhasznalok 
              ORDER BY id DESC";
    
    $stmt = $db->prepare($query);
    $stmt->execute();
    
    $users = $stmt->fetchAll();
    
    echo json_encode($users);
}
