<?php
require("_inc.php");

$stmt = $db->prepare("SELECT ID_przepis, nazwa, dania.ID
FROM posilki 
    JOIN dania ON dania.ID = ID_danie
    JOIN przepisy ON przepisy.ID = ID_przepis
WHERE czas_ugotowania IS NULL
ORDER BY czas_posilku ASC LIMIT 1");
$result = $stmt->execute();
while ($row = $result->fetchArray()) {
    echo $row["nazwa"] . "\n";

    $stmt = $db->prepare("SELECT produkty.nazwa, ilosc 
        FROM skladniki 
            JOIN przepisy ON przepisy.ID=ID_przepis 
            JOIN produkty ON produkty.ID=ID_produkt
        WHERE przepisy.ID=:przepis");
    $stmt->bindValue(':przepis', $row["ID_przepis"], SQLITE3_INTEGER);
    $result2 = $stmt->execute();
    while ($row2 = $result2->fetchArray()) {
        echo "  " . $row2["nazwa"] . ", " . $row2["ilosc"] . "\n";
    }

    echo "ENTER - potwierdz ugotowanie, SPACJA - pomiń";
    $odpowiedz = fgetc(STDIN);
    if ($odpowiedz == "\n") {
        $db->exec("UPDATE dania SET czas_ugotowania = CURRENT_TIMESTAMP WHERE ID = " . $row["ID"]);
        echo "Oznaczone jako ugotowane\n";
    }
}
?>