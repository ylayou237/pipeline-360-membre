-- Génération de données de test
-- Simulation de données pour une coopérative type Desjardins
-- 1 000 membres, 10 000 transactions, 3 000 produits

-- ── MEMBRES (1 000 enregistrements) ───────────────────────
DECLARE @i INT = 1;

DECLARE @villes  TABLE (id INT IDENTITY, v VARCHAR(20));
DECLARE @noms    TABLE (id INT IDENTITY, n VARCHAR(50));
DECLARE @prenoms TABLE (id INT IDENTITY, p VARCHAR(50));

INSERT INTO @villes  VALUES ('Lévis'),('Montréal');
INSERT INTO @noms    VALUES ('Tremblay'),('Gagnon'),('Lavoie'),
                            ('Bouchard'),('Côté'),('Roy'),
                            ('Fortin'),('Morin');
INSERT INTO @prenoms VALUES ('Martin'),('Sophie'),('Pierre'),
                            ('Marie'),('Jean'),('Julie'),
                            ('Michel'),('Isabelle');

WHILE @i <= 1000
BEGIN
    INSERT INTO MEMBRES (id_membre, nom, age, ville)
    VALUES (
        @i,
        (SELECT TOP 1 p FROM @prenoms ORDER BY NEWID()) + ' ' +
        (SELECT TOP 1 n FROM @noms ORDER BY NEWID()),
        18 + ABS(CHECKSUM(NEWID())) % 58,
        (SELECT TOP 1 v FROM @villes ORDER BY NEWID())
    );
    SET @i = @i + 1;
END;

-- ── TRANSACTIONS (10 000 enregistrements) ─────────────────
DECLARE @j INT = 1;

DECLARE @cats TABLE (id INT IDENTITY, c VARCHAR(50));
INSERT INTO @cats VALUES ('Épargne'),('Crédit'),
                         ('Hypothèque'),('Assurance'),
                         ('Investissement');

WHILE @j <= 10000
BEGIN
    INSERT INTO TRANSACTIONS
        (id_transaction, id_membre, date, montant, categorie)
    VALUES (
        @j,
        1 + ABS(CHECKSUM(NEWID())) % 1000,
        DATEADD(day, ABS(CHECKSUM(NEWID())) % 365, '2024-01-01'),
        ROUND(100 + (ABS(CHECKSUM(NEWID())) % 74900), 2),
        (SELECT TOP 1 c FROM @cats ORDER BY NEWID())
    );
    SET @j = @j + 1;
END;

-- ── PRODUITS (3 000 enregistrements) ──────────────────────
DECLARE @k INT = 1;

DECLARE @types TABLE (id INT IDENTITY, t VARCHAR(50));
INSERT INTO @types VALUES ('Chèques'),('Épargne'),
                          ('REER'),('CELI'),('Hypothèque');

WHILE @k <= 3000
BEGIN
    INSERT INTO PRODUITS
        (id_produit, id_membre, type_compte, pret_auto)
    VALUES (
        @k,
        1 + ABS(CHECKSUM(NEWID())) % 1000,
        (SELECT TOP 1 t FROM @types ORDER BY NEWID()),
        CASE WHEN ABS(CHECKSUM(NEWID())) % 2 = 0
             THEN 'Oui' ELSE 'Non' END
    );
    SET @k = @k + 1;
END;

-- Vérification des volumes générés
SELECT 'MEMBRES' AS table_name, COUNT(*) AS nb_lignes FROM MEMBRES
UNION ALL
SELECT 'TRANSACTIONS', COUNT(*) FROM TRANSACTIONS
UNION ALL
SELECT 'PRODUITS', COUNT(*) FROM PRODUITS;