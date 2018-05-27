<?php
// zainicjalizuj bazę danych jesli nie istnieje
$db = new SQLite3('data/database.db');
$db->exec(file_get_contents("data/_init.sql"));
?>