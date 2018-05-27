<?php
require("_inc.php");

$stmt = $db->prepare('SELECT ID, nazwa, COALESCE(ilosc, 0) AS ilosc
                      FROM produkty
                          LEFT JOIN zapasy ON ID_produkt = produkty.ID');
$result = $stmt->execute();
while ($row = $result->fetchArray()) {
    echo $row["ilosc"] . ", " . $row["nazwa"] . " (enter lub wpisz liczbę)\n";
    $odpowiedz = trim(fgets(STDIN));
    if ($odpowiedz || $odpowiedz == '0') {
        $stmt = $db->prepare('REPLACE INTO zapasy (ID_produkt, ilosc)VALUES(:produkt, :ilosc)');
        $stmt->bindValue(':ilosc', floatval($odpowiedz), SQLITE3_FLOAT);
        $stmt->bindValue(':produkt', $row["ID"], SQLITE3_INTEGER);
        $stmt->execute();
    }
}
 ?> 
