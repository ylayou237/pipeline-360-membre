-- STAGING : données brutes simulant un système bancaire type Desjardins
-- Les données arrivent ici avant transformation vers le DWH

-- Table des membres (clients)
CREATE TABLE MEMBRES (
    id_membre INT PRIMARY KEY,
    nom VARCHAR(100),
    age INT,
    ville VARCHAR(50),
    date_chargement DATETIME DEFAULT GETDATE()
);

-- Transactions financières des membres
CREATE TABLE TRANSACTIONS (
    id_transaction INT PRIMARY KEY,
    id_membre INT,
    date DATE,
    montant DECIMAL(12,2),
    categorie VARCHAR(50),
    date_chargement DATETIME DEFAULT GETDATE()
);

-- Produits bancaires associés aux membres
CREATE TABLE PRODUITS (
    id_produit INT PRIMARY KEY,
    id_membre INT,
    type_compte VARCHAR(50),
    pret_auto VARCHAR(3),
    date_chargement DATETIME DEFAULT GETDATE()
);