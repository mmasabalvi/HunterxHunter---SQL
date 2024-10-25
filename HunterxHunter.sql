CREATE DATABASE GreedIslandTournament
use GreedIslandTournament

CREATE TABLE Hunter
(
	HunterID VARCHAR(12) PRIMARY KEY,
	CHECK (HunterID LIKE '[A-Z][A-Z]-[0-9][0-9][0-9][0-9]-[0-9][0-9][0-9]'),
	HunterName VARCHAR(50) NOT NULL,
	CHECK (HunterName NOT LIKE '%[0-9]%'),
	HunterNenType VARCHAR(12) NOT NULL CHECK (HunterNenType IN ('Enhancer', 'Conjurer', 'Emitter', 'Specialist', 'Transmuter', 'Manipulator')), -- Use VARCHAR with a CHECK constraint	QuestsCompleted INT NOT NULL,
	HunterQuestsCompleted INT NOT NULL CHECK (HunterQuestsCompleted >= 0),  
	HunterBattlesWon INT NOT NULL CHECK (HunterBattlesWon >= 0), 
);

CREATE TABLE Card
(
    CardID VARCHAR(12) PRIMARY KEY,
	CHECK (CardID LIKE 'C-[0-9][0-9][0-9]'),
    CardName VARCHAR(50) NOT NULL,
	CHECK (CardName NOT LIKE '%[0-9]%'),
    CardType VARCHAR(10) NOT NULL CHECK (CardType IN ('Spell', 'Weapon', 'Healing', 'Summoning')),
    CardRarity VARCHAR(10) NOT NULL CHECK (CardRarity IN ('Common', 'Rare', 'Ultra Rare')) 
);

CREATE TABLE Location
(
    LocationID VARCHAR(12) PRIMARY KEY,
	CHECK (LocationID LIKE 'L-[0-9][0-9][0-9]'),
    LocationName VARCHAR(50) NOT NULL,
	CHECK (LocationName NOT LIKE '%[0-9]%'),
    LocationRegion VARCHAR(10) NOT NULL CHECK (LocationRegion IN ('Forest', 'Mountain', 'Beach')),
    LocationDifficultyLevel VARCHAR(10) NOT NULL CHECK (LocationDifficultyLevel IN ('Easy', 'Medium', 'Hard')) 
);

CREATE TABLE Quest
(
    QuestID VARCHAR(12) PRIMARY KEY,
	CHECK (QuestID LIKE 'Q-[0-9][0-9][0-9]'),
    QuestName VARCHAR(50) NOT NULL,
	CHECK (QuestName NOT LIKE '%[0-9]%'),
    LocationID VARCHAR(12) NOT NULL,
	FOREIGN KEY (LocationID) REFERENCES Location(LocationID),
	QuestReward VARCHAR(50) NOT NULL -- any constraint possible?
);

CREATE TABLE Battle
(
    BattleID VARCHAR(12) PRIMARY KEY,
	CHECK (BattleID LIKE 'B-[0-9][0-9][0-9]'),
	BattleDate DATE NOT NULL,
	BattleTime TIME NOT NULL,
    LocationID VARCHAR(12) NOT NULL,
	FOREIGN KEY (LocationID) REFERENCES Location(LocationID),
	Hunter1_ID VARCHAR(12) NOT NULL,
	FOREIGN KEY (Hunter1_ID) REFERENCES Hunter(HunterID),
	Hunter2_ID VARCHAR(12) NOT NULL,
	FOREIGN KEY (Hunter2_ID) REFERENCES Hunter(HunterID),
	CHECK (Hunter1_ID <> Hunter2_ID), -- Hunter1 and 2 not the same
	BattleType VARCHAR(12) NOT NULL CHECK (BattleType IN ('Duel', 'Team Battle'))
);

CREATE TABLE Performance
(
    PerformanceID VARCHAR(10) PRIMARY KEY,
	CHECK (PerformanceID LIKE 'P-[0-9][0-9][0-9]'),
    BattleID VARCHAR(12) NOT NULL, 
	FOREIGN KEY (BattleID) REFERENCES Battle(BattleID),
    HunterID VARCHAR(12) NOT NULL, 
	FOREIGN KEY (HunterID) REFERENCES Hunter(HunterID),
    DamageDealt INT NOT NULL CHECK (DamageDealt >= 0),
    DamageTaken INT NOT NULL CHECK (DamageTaken >= 0),
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


--INSERT INTO Card (CardID, CardName, CardType, CardRarity) 
--SELECT CardID, CardName, CardType, CardRarity                         
--FROM dbo.cards; 

--drop table cards


--INSERT INTO Hunter (HunterID, HunterName, HunterNenType, HunterQuestsCompleted, HunterBattlesWon) 
--SELECT HunterID, HunterName, HunterNenType, HunterQuestsCompleted, HunterBattlesWon                         
--FROM dbo.hunters; 

--drop table hunters


INSERT INTO Location (LocationID, LocationName, LocationRegion, LocationDifficultyLevel) VALUES
('L-001', 'Whispering Woods', 'Forest', 'Easy'),
('L-002', 'Misty Mountains', 'Mountain', 'Hard'),
('L-003', 'Sunset Shore', 'Beach', 'Medium'),
('L-004', 'Enchanted Grove', 'Forest', 'Medium'),
('L-005', 'Frostpeak Summit', 'Mountain', 'Hard'),
('L-006', 'Coral Cove', 'Beach', 'Easy'),
('L-007', 'Shadowleaf Forest', 'Forest', 'Hard'),
('L-008', 'Thunderclap Peaks', 'Mountain', 'Medium'),
('L-009', 'Tranquil Bay', 'Beach', 'Easy'),
('L-010', 'Ancient Redwoods', 'Forest', 'Medium'),
('L-011', 'Avalanche Alley', 'Mountain', 'Hard'),
('L-012', 'Shipwreck Shores', 'Beach', 'Medium'),
('L-013', 'Mushroom Meadow', 'Forest', 'Easy'),
('L-014', 'Dragon`s Spine Ridge', 'Mountain', 'Hard'),
('L-015', 'Mermaid Lagoon', 'Beach', 'Medium'),
('L-016', 'Firefly Glade', 'Forest', 'Easy'),
('L-017', 'Icewind Pass', 'Mountain', 'Medium'),
('L-018', 'Sandcastle Beach', 'Beach', 'Easy'),
('L-019', 'Twilight Thicket', 'Forest', 'Hard'),
('L-020', 'Cloudhaven Cliffs', 'Mountain', 'Medium');


INSERT INTO Quest (QuestID, QuestName, LocationID, QuestReward) VALUES
('Q-001', 'Rescue the Lost Kitten', 'L-001', 'Healing Potion'),
('Q-002', 'Defeat the Mountain Troll', 'L-002', 'Obsidian Sword'),
('Q-003', 'Find the Hidden Treasure', 'L-003', 'Gold Coins x100'),
('Q-004', 'Collect Rare Herbs', 'L-004', 'Herbal Medicine Kit'),
('Q-005', 'Slay the Ice Dragon', 'L-005', 'Dragonscale Armor'),
('Q-006', 'Clean the Beach', 'L-006', 'Coral Necklace'),
('Q-007', 'Banish the Dark Spirit', 'L-007', 'Spirit Ward Amulet'),
('Q-008', 'Climb the Highest Peak', 'L-008', 'Winged Boots'),
('Q-009', 'Rescue Stranded Sailors', 'L-009', 'Captain`s Hat'),
('Q-010', 'Protect the Ancient Tree', 'L-010', 'Wooden Staff'),
('Q-011', 'Survive the Avalanche', 'L-011', 'Thermal Cloak'),
('Q-012', 'Recover Lost Artifacts', 'L-012', 'Underwater Breathing Potion'),
('Q-013', 'Gather Glowing Mushrooms', 'L-013', 'Night Vision Goggles'),
('Q-014', 'Tame the Wild Wyvern', 'L-014', 'Wyvern Whistle'),
('Q-015', 'Negotiate with Merfolk', 'L-015', 'Trident of the Seas'),
('Q-016', 'Catch Fireflies', 'L-016', 'Lantern of Eternal Light'),
('Q-017', 'Break the Ice Curse', 'L-017', 'Flame Gloves'),
('Q-018', 'Build the Ultimate Sandcastle', 'L-018', 'Shovel of Plenty'),
('Q-019', 'Uncover the Forest`s Secrets', 'L-019', 'Map of Mysteries'),
('Q-020', 'Harness the Power of Lightning', 'L-020', 'Thunder Hammer');

INSERT INTO Battle (BattleID, BattleDate, BattleTime, LocationID, Hunter1_ID, Hunter2_ID, BattleType) 
VALUES
('B-001', '2024-10-15', '10:00:00', 'L-001', 'GI-2024-001', 'GI-2024-002', 'Duel'),
('B-002', '2024-10-16', '14:30:00', 'L-002', 'GI-2024-003', 'GI-2024-004', 'Team Battle'),
('B-003', '2024-10-17', '09:15:00', 'L-003', 'GI-2024-005', 'GI-2024-006', 'Duel'),
('B-004', '2024-10-18', '16:45:00', 'L-004', 'GI-2024-007', 'GI-2024-008', 'Team Battle'),
('B-005', '2024-10-19', '11:30:00', 'L-005', 'GI-2024-009', 'GI-2024-010', 'Duel'),
('B-006', '2024-10-20', '13:00:00', 'L-006', 'GI-2024-001', 'GI-2024-003', 'Team Battle'),
('B-007', '2024-10-21', '15:20:00', 'L-007', 'GI-2024-002', 'GI-2024-004', 'Duel'),
('B-008', '2024-10-22', '10:45:00', 'L-008', 'GI-2024-005', 'GI-2024-007', 'Team Battle'),
('B-009', '2024-10-23', '12:30:00', 'L-009', 'GI-2024-006', 'GI-2024-008', 'Duel'),
('B-010', '2024-10-24', '17:00:00', 'L-010', 'GI-2024-009', 'GI-2024-010', 'Team Battle'),
('B-011', '2024-10-25', '09:30:00', 'L-011', 'GI-2024-001', 'GI-2024-005', 'Duel'),
('B-012', '2024-10-26', '14:15:00', 'L-012', 'GI-2024-002', 'GI-2024-006', 'Team Battle'),
('B-013', '2024-10-27', '11:00:00', 'L-013', 'GI-2024-003', 'GI-2024-007', 'Duel'),
('B-014', '2024-10-28', '16:30:00', 'L-014', 'GI-2024-004', 'GI-2024-008', 'Team Battle'),
('B-015', '2024-10-29', '13:45:00', 'L-015', 'GI-2024-009', 'GI-2024-001', 'Duel'),
('B-016', '2024-10-30', '10:15:00', 'L-016', 'GI-2024-010', 'GI-2024-002', 'Team Battle'),
('B-017', '2024-10-31', '15:00:00', 'L-017', 'GI-2024-005', 'GI-2024-003', 'Duel'),
('B-018', '2024-11-01', '12:45:00', 'L-018', 'GI-2024-006', 'GI-2024-004', 'Team Battle'),
('B-019', '2024-11-02', '17:30:00', 'L-019', 'GI-2024-007', 'GI-2024-009', 'Duel'),
('B-020', '2024-11-03', '09:00:00', 'L-020', 'GI-2024-008', 'GI-2024-010', 'Team Battle');

INSERT INTO Performance (PerformanceID, BattleID, HunterID, DamageDealt, DamageTaken, SpecialMovesUsed) 
VALUES
('P-001', 'B-001', 'GI-2024-001', 150, 100, 'Fireball, Ice Shard'),
('P-002', 'B-001', 'GI-2024-002', 120, 130, 'Thunder Strike, Heal'),
('P-003', 'B-002', 'GI-2024-003', 200, 80, 'Earth Quake, Rock Throw'),
('P-004', 'B-002', 'GI-2024-004', 180, 90, 'Wind Slash, Tornado'),
('P-005', 'B-003', 'GI-2024-005', 160, 110, 'Water Jet, Bubble Shield'),
('P-006', 'B-003', 'GI-2024-006', 140, 120, 'Poison Dart, Venom Bite'),
('P-007', 'B-004', 'GI-2024-007', 190, 70, 'Light Beam, Holy Shield'),
('P-008', 'B-004', 'GI-2024-008', 170, 100, 'Shadow Strike, Dark Veil'),
('P-009', 'B-005', 'GI-2024-009', 210, 60, 'Lightning Bolt, Static Field'),
('P-010', 'B-005', 'GI-2024-010', 130, 140, 'Nature`s Wrath, Vine Whip'),
('P-011', 'B-006', 'GI-2024-001', 180, 90, 'Meteor Shower, Magma Burst'),
('P-012', 'B-006', 'GI-2024-003', 160, 110, 'Frost Nova, Blizzard'),
('P-013', 'B-007', 'GI-2024-002', 150, 120, 'Thunderclap, Chain Lightning'),
('P-014', 'B-007', 'GI-2024-004', 170, 100, 'Sandstorm, Desert Mirage'),
('P-015', 'B-008', 'GI-2024-005', 200, 80, 'Tidal Wave, Whirlpool'),
('P-016', 'B-008', 'GI-2024-007', 190, 90, 'Solar Flare, Cosmic Beam'),
('P-017', 'B-009', 'GI-2024-006', 140, 130, 'Toxic Cloud, Acid Spray'),
('P-018', 'B-009', 'GI-2024-008', 160, 110, 'Gravity Well, Black Hole'),
('P-019', 'B-010', 'GI-2024-009', 220, 50, 'Thunderstorm, Electric Field'),
('P-020', 'B-010', 'GI-2024-010', 120, 150, 'Pollen Burst, Spore Cloud');


INSERT INTO Victor (BattleID, WinningHunterID) VALUES
('B-001', 'GI-2024-001'),
('B-002', 'GI-2024-003'),
('B-003', 'GI-2024-005'),
('B-004', 'GI-2024-007'),
('B-005', 'GI-2024-009'),
('B-006', 'GI-2024-001'),
('B-007', 'GI-2024-002'),
('B-008', 'GI-2024-005'),
('B-009', 'GI-2024-006'),
('B-010', 'GI-2024-009'),
('B-011', 'GI-2024-001'),
('B-012', 'GI-2024-002'),
('B-013', 'GI-2024-003'),
('B-014', 'GI-2024-004'),
('B-015', 'GI-2024-009'),
('B-016', 'GI-2024-010'),
('B-017', 'GI-2024-005'),
('B-018', 'GI-2024-006'),
('B-019', 'GI-2024-007'),
('B-020', 'GI-2024-008');


INSERT INTO Collection (HunterID, CardID, Quantity) VALUES
('GI-2024-001', 'C-001', 3),
('GI-2024-001', 'C-002', 2),
('GI-2024-002', 'C-003', 1),
('GI-2024-002', 'C-004', 4),
('GI-2024-003', 'C-005', 2),
('GI-2024-003', 'C-006', 3),
('GI-2024-004', 'C-007', 1),
('GI-2024-004', 'C-008', 2),
('GI-2024-005', 'C-009', 3),
('GI-2024-005', 'C-010', 1),
('GI-2024-006', 'C-011', 2),
('GI-2024-006', 'C-012', 4),
('GI-2024-007', 'C-013', 1),
('GI-2024-007', 'C-014', 3),
('GI-2024-008', 'C-015', 2),
('GI-2024-008', 'C-016', 1),
('GI-2024-009', 'C-017', 4),
('GI-2024-009', 'C-018', 2),
('GI-2024-010', 'C-019', 3),
('GI-2024-010', 'C-020', 1);


SELECT * FROM Collection;

Select * from Card

Select * from Battle

-- Query 1:
SELECT HunterName, HunterNenType
FROM Hunter

-- Query 2:
SELECT top 1 c2.CardType, SUM(c.Quantity) AS total_quantity
FROM Collection c
JOIN Card c2 ON c.CardID = c2.CardID
GROUP BY c2.CardType
ORDER BY total_quantity DESC;

--Query 3:
select LocationName,LocationDifficultyLevel from Location
where LocationDifficultyLevel='Hard'

--Query 4:
select HunterID, sum(Quantity) as TotalCardsCollected
from collection
where HunterID='GI-2024-004'
group by HunterID


--Query 5:
select * from Hunter where hunterID in (select WinningHunterID from Victor
group by WinningHunterID having count(WinningHunterID)>0)
--select WinningHunterID, count(WinningHunterID) as victories from Victor
--group by WinningHunterID having count(WinningHunterID)>2

--Select *
--from Hunter h join Victor v on h.HunterID = v.WinningHunterID
--group by WinningHunterID having count(WinningHunterID)>2;



--Query 6:
SELECT top 1 h.HunterName, h.HunterID, COUNT(v.WinningHunterID) AS victories
FROM Victor v
JOIN Battle b ON v.BattleID = b.BattleID
JOIN Location l ON b.LocationID = l.LocationID
JOIN Hunter h ON v.WinningHunterID = h.HunterID
WHERE l.LocationRegion = 'Forest'
GROUP BY h.HunterID, h.HunterName
ORDER BY victories DESC;

--Query 7:
select * from Hunter
where HunterQuestsCompleted>5

--Query 8:
select HunterNenType, avg(HunterQuestsCompleted) as averageQuests from Hunter
where HunterNenType='Enhancer'
group by HunterNenType;


-- Query 10: 
SELECT H.HunterID, H.HunterName, sum(P.damagedealt) as TotalDamageDealt
FROM Hunter H LEFT JOIN Performance P
on H.HunterID = P.HunterID
GROUP BY H.HunterID, H.hunterName;

-- Query 11
SELECT * 
FROM Card
WHERE CardType = 'Spell';

-- Query 12
SELECT H.*, C.CardID ,CC.CardRarity 
FROM Hunter H 
JOIN Collection C on h.HunterID = C.HunterID 
JOIN Card CC on C.CardID = CC.CardID
where CC.CardRarity = 'Ultra Rare';

-- Query 13 
SELECT TOP 3 H.HunterID, H.HunterName, sum(P.damagedealt) as TotalDamageDealt -- like Query 10
FROM Hunter H LEFT JOIN Performance P
on H.HunterID = P.HunterID
GROUP BY H.HunterID, H.hunterName
ORDER BY TotalDamageDealt desc;

-- Query 14
Select L.LocationRegion, COUNT(Q.QuestID) as NumberofQuests
FROM Quest Q join LOCATION L
on Q.LocationID = L.LocationID
WHERE L.LocationRegion = 'Forest'
GROUP BY L.LocationRegion;

--Query 15
Select H.HunterName, H.HunterID, sum(C.Quantity) as TotalCards
From Hunter H Left join Collection C
on H.HunterID = C.HunterID
Group by H.HunterID, H.HunterName;

-- Query 16
Select B.*, L.LocationRegion
FROM Battle B join LOCATION L
on B.LocationID = L.LocationID
WHERE L.LocationRegion = 'Mountain'

-- Query 17
Select B.*
From Battle B
Where B.BattleDate = '2024-11-1';

-- Query 18 --add hunters with more than 1 utlra rare cards owned please
SELECT Top 3 H.HunterID, H.HunterName, count(CC.CardRarity) as [Ultra Rare Cards Owned]
FROM Hunter H 
JOIN Collection C on h.HunterID = C.HunterID 
JOIN Card CC on C.CardID = CC.CardID
where CC.CardRarity = 'Ultra Rare'
Group by H.HunterID, H.HunterName
Order by [Ultra Rare Cards Owned] desc;

-- Query 19
Select L.LocationRegion, count(B.BattleID) as [Total Battles Held]
FROM Battle B join LOCATION L
on B.LocationID = L.LocationID
Group by L.LocationRegion;

-- Query 20 
Select V.WinningHunterID as [Hunters Won in Every Region]
From Victor V inner join Battle B
on V.BattleID = B.BattleID 
Inner Join Location L on B.LocationID = L.LocationID 
GROUP BY V.WinningHunterID
HAVING COUNT(DISTINCT L.LocationRegion) = 3;			--(SELECT COUNT(DISTINCT LocationRegion) FROM Location);



--where L.LocationRegion = 'Mountain' AND L.LocationRegion = 'Forest' AND L.LocationRegion = 'Beach';


--Query 23:
select top 1 hunterID,DamageDealt from Performance order by DamageDealt desc;


--Query 24
SELECT HunterID, sum(Quantity) AS rareCardCount
FROM Collection c
join Card cc ON c.cardID=cc.CardID
WHERE CardRarity = 'Rare'
GROUP BY HunterID
order by rareCardCount desc;