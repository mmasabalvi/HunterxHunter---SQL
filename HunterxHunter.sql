CREATE DATABASE GreedIslandTournament
use GreedIslandTournament

CREATE TABLE Hunter
(
	HunterID VARCHAR(12) PRIMARY KEY,
	HunterName VARCHAR(50) NOT NULL,
	HunterNenType VARCHAR(10) NOT NULL CHECK (HunterNenType IN ('Enhancer', 'Conjurer', 'Emitter')), -- Use VARCHAR with a CHECK constraint	QuestsCompleted INT NOT NULL,
	HunterQuestsCompleted INT NOT NULL,
	HunterBattlesWon INT NOT NULL
);

CREATE TABLE Card
(
    CardID VARCHAR(12) PRIMARY KEY,
    CardName VARCHAR(50) NOT NULL,
    CardType VARCHAR(10) NOT NULL CHECK (CardType IN ('Spell', 'Weapon', 'Healing')),
    CardRarity VARCHAR(10) NOT NULL CHECK (CardRarity IN ('Common', 'Rare', 'Ultra Rare')) 
);

CREATE TABLE Location
(
    LocationID VARCHAR(12) PRIMARY KEY,
    LocationName VARCHAR(50) NOT NULL,
    LocationRegion VARCHAR(10) NOT NULL CHECK (LocationRegion IN ('Forest', 'Mountain', 'Beach')),
    LocationDifficultyLevel VARCHAR(10) NOT NULL CHECK (LocationDifficultyLevel IN ('Easy', 'Medium', 'Hard')) 
);

CREATE TABLE Quest
(
    QuestID VARCHAR(12) PRIMARY KEY,
    QuestName VARCHAR(50) NOT NULL,
    LocationID VARCHAR(12) NOT NULL,
	FOREIGN KEY (LocationID) REFERENCES Location(LocationID),
	QuestReward VARCHAR(50) NOT NULL
);

CREATE TABLE Battle
(
    BattleID VARCHAR(12) PRIMARY KEY,
	BattleDate DATE NOT NULL,
	BattleTime TIME NOT NULL,
    LocationID VARCHAR(12) NOT NULL,
	FOREIGN KEY (LocationID) REFERENCES Location(LocationID),
	Hunter1_ID VARCHAR(12) NOT NULL,
	FOREIGN KEY (Hunter1_ID) REFERENCES Hunter(HunterID),
	Hunter2_ID VARCHAR(12) NOT NULL,
	FOREIGN KEY (Hunter2_ID) REFERENCES Hunter(HunterID),
	BattleType VARCHAR(12) NOT NULL CHECK (BattleType IN ('Duel', 'Team Battle'))
);

CREATE TABLE Performance
(
    PerformanceID VARCHAR(10) PRIMARY KEY,
    BattleID VARCHAR(12) NOT NULL, 
	FOREIGN KEY (BattleID) REFERENCES Battle(BattleID),
    HunterID VARCHAR(12) NOT NULL, 
	FOREIGN KEY (HunterID) REFERENCES Hunter(HunterID),
    DamageDealt INT NOT NULL,
    DamageTaken INT NOT NULL,
    SpecialMovesUsed VARCHAR(255) NOT NULL
);

CREATE TABLE Victor --relationship table
(
    BattleID VARCHAR(12) PRIMARY KEY, -- Assuming each battle has one victor
	FOREIGN KEY (BattleID) REFERENCES Battle(BattleID),
    WinningHunterID VARCHAR(12) NOT NULL, -- not used as primary key as then we'll enforce that one hunter can just win 1 battle
    FOREIGN KEY (WinningHunterID) REFERENCES Hunter(HunterID)
);

CREATE TABLE Collection --relationship table
(
    HunterID VARCHAR(12) NOT NULL,
	FOREIGN KEY (HunterID) REFERENCES Hunter(HunterID),
    CardID VARCHAR(12) NOT NULL,
	FOREIGN KEY (CardID) REFERENCES Card(CardID),
    Quantity INT NOT NULL,
    PRIMARY KEY (HunterID, CardID), -- Composite primary key
);






