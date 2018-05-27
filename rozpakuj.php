<?php
require("_inc.php");

$stmt = $db->prepare("SELECT produkty.ID, produkty.nazwa, sum(skladniki.ilosc) - sum(zapasy.ilosc) AS ilosc
FROM posilki 
    JOIN dania ON dania.ID = ID_danie
    JOIN przepisy ON przepisy.ID = dania.ID_przepis
    JOIN skladniki ON skladniki.ID_przepis = przepisy.ID
    JOIN produkty ON produkty.ID = skladniki.ID_produkt
    JOIN zapasy ON zapasy.ID_produkt = produkty.ID
WHERE czas_posilku < DATETIME(CURRENT_TIMESTAMP, '+24 hours')
GROUP BY 1, 2;");
$result = $stmt->execute();
while ($row = $result->fetchArray()) {
    echo $row["nazwa"] . ", " . $row["ilosc"] . " (enter lub wpisz liczbę)\n";

    $odpowiedz = trim(fgets(STDIN)) ?: $row["ilosc"];

    $zapas = $db->querySingle("SELECT ilosc FROM zapasy WHERE ID_produkt=".$row["ID"]) ?: 0;
    $stmt = $db->prepare('REPLACE INTO zapasy (ID_produkt, ilosc)VALUES(:produkt, :ilosc)');
    $stmt->bindValue(':ilosc', floatval($odpowiedz) + $zapas, SQLITE3_FLOAT);
    $stmt->bindValue(':produkt', $row["ID"], SQLITE3_INTEGER);
    $stmt->execute();
}
?>