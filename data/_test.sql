-- LISTA ZAKUPÓW
--  1. Dane wejściowe: posiłki na najbliższe 24 godziny
--  2. Weź posiłki do zjedzenia w ciągu 24 godzin
SELECT * FROM posilki WHERE czas_posilku < CURRENT_TIMESTAMP + 24*60*60*1000;

--  3. Weź nieugotowane dania dla tych posiłków
SELECT * 
FROM posilki JOIN dania ON dania.ID = ID_danie
WHERE czas_posilku < CURRENT_TIMESTAMP + 24*60*60*1000;

--  4. Weź przepisy dla tych dań
SELECT * 
FROM posilki 
    JOIN dania ON dania.ID = ID_danie
    JOIN przepisy ON przepisy.ID = ID_przepis
WHERE czas_posilku < CURRENT_TIMESTAMP + 24*60*60*1000;

--  5. Weź składniki dla tych przepisów
SELECT * 
FROM posilki 
    JOIN dania ON dania.ID = ID_danie
    JOIN przepisy ON przepisy.ID = ID_przepis
    JOIN skladniki ON przepisy.ID = ID_przepis
WHERE czas_posilku < CURRENT_TIMESTAMP + 24*60*60*1000;


--  6. Weź produkty dla tych składników
SELECT * 
FROM posilki 
    JOIN dania ON dania.ID = ID_danie
    JOIN przepisy ON przepisy.ID = ID_przepis
    JOIN skladniki ON przepisy.ID = ID_przepis
    JOIN produkty ON produkty.ID = ID_produkt
WHERE czas_posilku < CURRENT_TIMESTAMP + 24*60*60*1000;

--  7. Pogrupuj po typie produktu i zsumuj potrzebną ilość
SELECT produkty.ID, sum(skladniki.ilosc) 
FROM posilki 
    JOIN dania ON dania.ID = ID_danie
    JOIN przepisy ON przepisy.ID = ID_przepis
    JOIN skladniki ON przepisy.ID = ID_przepis
    JOIN produkty ON produkty.ID = ID_produkt
WHERE czas_posilku < CURRENT_TIMESTAMP + 24*60*60*1000
GROUP BY produkty.ID;


--  8. Weź zapasy dla każdego produktu
SELECT produkty.ID, sum(skladniki.ilosc) 
FROM posilki 
    JOIN dania ON dania.ID = ID_danie
    JOIN przepisy ON przepisy.ID = ID_przepis
    JOIN skladniki ON przepisy.ID = ID_przepis
    JOIN produkty ON produkty.ID = ID_produkt
    JOIN zapasy ON zapasy.ID_produkty = produkty.ID
WHERE czas_posilku < CURRENT_TIMESTAMP + 24*60*60*1000
GROUP BY produkty.ID;

--  9. Odejmij posiadaną ilość
SELECT produkty.nazwa, sum(skladniki.ilosc) - sum(zapasy.ilosc)
FROM posilki 
    JOIN dania ON dania.ID = ID_danie
    JOIN przepisy ON przepisy.ID = dania.ID_przepis
    JOIN skladniki ON skladniki.ID_przepis = przepisy.ID
    JOIN produkty ON produkty.ID = skladniki.ID_produkt
    JOIN zapasy ON zapasy.ID_produkt = produkty.ID
WHERE czas_posilku < CURRENT_TIMESTAMP + 24*60*60*1000
GROUP BY 1;

-- ROZPAKUJ
UPDATE zapasy SET ilosc += X WHERE ID_produkt = 5 

-- GOTOWANIE
-- 1. Weź przepisy, rozpakowane produkty, odejmij z lodówki
-- 2. Weź przepis na najbliższy nieugotowany posiłek
SELECT * FROM posilki JOIN przepisy ON przepisy.ID = ID_przepis
WHERE czas_ugotowania IS NULL
ORDER BY czas_posilku ASC LIMIT 1

-- 3. Weź składniki
SELECT * 
FROM posilki 
    JOIN przepisy ON przepisy.ID = posilki.ID_przepis
    JOIN skladniki ON przepisy.ID = skladniki.ID_przepis
WHERE czas_ugotowania IS NULL
ORDER BY czas_posilku ASC LIMIT 1

-- 4. Weź produkty
SELECT produkty.nazwa, produkty.ilosc 
FROM posilki 
    JOIN przepisy ON przepisy.ID = posilki.ID_przepis
    JOIN skladniki ON przepisy.ID = skladniki.ID_przepis
    JOIN produkty ON skladniki.ID_produkt = produkty.ID
WHERE czas_ugotowania IS NULL
ORDER BY czas_posilku ASC LIMIT 1


-- UGOTUJ
-- 5. Oznacz jako ugotowane
UPDATE posilki SET czas_ugotowania = CURRENT_TIMESTAMP WHERE ID = x
-- 6. Odejmij od zapasów
UPDATE zapasy SET ilosc -= X WHERE ID_produkty = Z

-- JEDZENIE
-- Co mam zjesc?
-- 1. Weź posiłek, który był zaplanowany na dany dzień i godzinę
--    Weź najbliższy posiłek
SELECT * FROM posilki
ORDER BY czas_posilku ASC LIMIT 1
-- 2. Weź dla niego danie i nazwę przepisu
SELECT nazwa, posilki.porcja, czas_posilku
FROM posilki
    JOIN dania ON ID_danie = dania.id
    JOIN przepisy ON ID_przepis = przepisy.ID
ORDER BY czas_posilku ASC LIMIT 1

-- Gdy już zjedzone (niezależnie czy faktycznie zjedzone)
UPDATE dania SET ilosc -= K WHERE ID = Z
DELETE FROM posilki WHERE ID = X

-- LODÓWKA
-- 1. Weź zapasy
SELECT * FROM zapasy
-- 2. Połącz z produktami
SELECT * 
FROM zapasy
    JOIN produkty ON ID_produkt = produkty.ID

-- Aktaulizuj stan
-- Enter
-- NIC
-- Wpisalem liczbę W
UPDATE zapasy SET ilosc=W WHERE ID_produkt = X