<?php
require("_inc.php");

$stmt = $db->prepare("SELECT produkty.nazwa, sum(skladniki.ilosc) - sum(zapasy.ilosc) AS ilosc
FROM posilki 
    JOIN dania ON dania.ID = ID_danie
    JOIN przepisy ON przepisy.ID = dania.ID_przepis
    JOIN skladniki ON skladniki.ID_przepis = przepisy.ID
    JOIN produkty ON produkty.ID = skladniki.ID_produkt
    JOIN zapasy ON zapasy.ID_produkt = produkty.ID
WHERE czas_posilku < DATETIME(CURRENT_TIMESTAMP, '+24 hours')
GROUP BY 1;");
$result = $stmt->execute();
while ($row = $result->fetchArray()) {
    echo $row["nazwa"] . ", " . $row["ilosc"] . "\n";
}
?>