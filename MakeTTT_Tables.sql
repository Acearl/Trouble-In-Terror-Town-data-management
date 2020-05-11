USE TTT;
DROP TABLE IF EXISTS Round_Players;
DROP TABLE IF EXISTS Roll_Data;
DROP TABLE IF EXISTS Menu_Buys;
DROP TABLE IF EXISTS Deaths;
DROP TABLE IF EXISTS Players;
DROP TABLE IF EXISTS Rounds;
DROP TABLE IF EXISTS Items;



CREATE TABLE Rounds(
	round_ID nvarchar(100) PRIMARY KEY NOT NULL,
	Date_Time datetime NULL,
	Durration nvarchar(50) NULL,
	Map nvarchar(50) NULL,
	FactionWon nvarchar(50) NULL
);	
CREATE TABLE Items(
	item_ID int PRIMARY KEY NOT NULL,
	item_Name nvarchar(50) UNIQUE NOT NULL
	);
CREATE TABLE Players(
	player_ID int UNIQUE NOT NULL,
	steam_ID nvarchar(100) PRIMARY KEY NOT NULL,
	IRL_Name nvarchar(25) NULL
);
CREATE TABLE Round_Players(
	round_ID nvarchar(100) not null REFERENCES Rounds(round_ID),
	steam_ID nvarchar(100) not null REFERENCES Players(steam_ID)
);
CREATE TABLE Roll_Data(
	round_ID nvarchar(100) not null REFERENCES Rounds(round_ID),
	steam_ID nvarchar(100) not null REFERENCES Players(steam_ID),
	role nvarchar(50),
	Time_in_Round time not null
);
CREATE TABLE Menu_Buys(
	round_ID nvarchar(100) not null REFERENCES Rounds(round_ID),
	steam_ID nvarchar(100) not null REFERENCES Players(steam_ID),
	item_Name nvarchar(50) not null REFERENCES Items(item_Name),
	Time_in_Round time not null
);
CREATE TABLE Deaths(
	round_ID nvarchar(100) not null REFERENCES Rounds(round_ID),
	Killer nvarchar(100) null REFERENCES Players(steam_ID),
	Victim nvarchar(100) not null REFERENCES Players(steam_ID),
	death_cause nvarchar(50) not null,
	Time_in_Round time not null,
	Weapon_Name nvarchar(50) null
);