<?php
require("_inc.php");

$stmt = $db->prepare('SELECT posilki.ID AS ID_posilek, ID_danie, nazwa, porcja, czas_posilku
                      FROM posilki
                          JOIN dania ON ID_danie = dania.id
                          JOIN przepisy ON ID_przepis = przepisy.ID
                      ORDER BY czas_posilku ASC LIMIT 1');

$result = $stmt->execute();
while ($row = $result->fetchArray()) {
    echo $row["nazwa"] . ", " . $row["porcja"] . ", " . $row["czas_posilku"] . "\n";
    echo "(enter aby potwierdzić zjedzenie/wyrzucenie, spacja - pominięcie)\n";
    $odpowiedz = fgetc(STDIN);
    if ($odpowiedz == "\n") {
        echo "Zjedzone! Aktualizuję bazę... \n";

        $stmt = $db->prepare('DELETE FROM posilki WHERE ID = :id');
        $stmt->bindValue(':id', $row["ID_posilek"], SQLITE3_INTEGER);
        $stmt->execute();

        $stmt = $db->prepare('UPDATE dania SET ilosc = ilosc - :ilosc WHERE ID = :id');
        $stmt->bindValue(':ilosc', $row["porcja"], SQLITE3_FLOAT);
        $stmt->bindValue(':id', $row["ID_danie"], SQLITE3_INTEGER);
        $stmt->execute();
    }
}
 ?> 
