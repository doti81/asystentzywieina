-- ENCYKLOPEDIA (Niezmienne)

    -- typy_produktow (informacje o produktach)
    CREATE TABLE IF NOT EXISTS produkty (
        ID INTEGER PRIMARY KEY NOT NULL,
        nazwa VARCHAR NOT NULL
    ); 

    DELETE FROM produkty;
    INSERT INTO produkty VALUES(1, "jajko");
    INSERT INTO produkty VALUES(2, "mleko");

    -- przepisy (jaki produkt zuzyc aby dostac danie)
    CREATE TABLE IF NOT EXISTS przepisy (
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        nazwa VARCHAR NOT NULL,
        kalorie INTEGER,
        rodzaj_posilku INTEGER -- 1 - sniadanie, 5 - kolacja
    ); 

        -- ("omlet", 100, 24 godziny)
        -- ("kotlet z surówką")

    CREATE TABLE IF NOT EXISTS skladniki (
        ID_produkt INTEGER REFERENCES produkty(ID),
        ID_przepis INTEGER REFERENCES przepisy(ID),
        ilosc REAL
    );

-- ŚWIAT (Dynamiczne)

    -- lodowka (jakie produkty mam w lodowce)
    CREATE TABLE IF NOT EXISTS zapasy (
        ID_produkt INTEGER PRIMARY KEY REFERENCES produkty(ID),
        ilosc REAL
    );

    -- dania (gotowe do zjedzenia)
    CREATE TABLE IF NOT EXISTS dania (
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ID_przepis INTEGER REFERENCES przepisy(ID),
        czas_ugotowania INTEGER,
        ilosc REAL
    );

        -- ("omlet", "dzisiaj 12:00", "jutro 12:00")

    -- posilki (jakie danie kiedy zjesc)
    CREATE TABLE IF NOT EXISTS posilki (
        ID INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        ID_danie INTEGER REFERENCES dania(ID),

        porcja REAL,
        czas_posilku INTEGER -- kiedy ma byc zjedzone
    );

        -- ("omlet", 0.5, "8:00")
        -- ("omlet", 0.5, "14:00")

-- DANE TESTOWE
-- INSERT INTO posilki (1, 1, 0.5, CURRENT_TIMESTAMP);