USE [TTT]
GO
DROP TABLE IF EXISTS Round_Players;
DROP TABLE IF EXISTS Roll_Changes;
DROP TABLE IF EXISTS Menu_Buys;
DROP TABLE IF EXISTS Deaths;
DROP TABLE IF EXISTS Players;
DROP TABLE IF EXISTS Rounds;
DROP TABLE IF EXISTS Items;

GO


CREATE TABLE Rounds(
	round_ID int PRIMARY KEY IDENTITY NOT NULL,
	Date_Time datetime NULL,
	Durration time(7) NULL,
	Map nvarchar(50) NULL,
	FactionWon nvarchar(50) NULL
);	
CREATE TABLE Items(
	item_ID int PRIMARY KEY IDENTITY NOT NULL,
	item_Name nvarchar(50)
	);
CREATE TABLE Players(
	player_ID int IDENTITY NOT NULL,
	steam_ID decimal PRIMARY KEY NOT NULL,
	IRL_Name nvarchar(25)
);
CREATE TABLE Round_Players(
	round_ID int not null REFERENCES Rounds(round_ID),
	steam_ID decimal not null REFERENCES Players(steam_ID)
);
CREATE TABLE Roll_Changes(
	round_ID int not null REFERENCES Rounds(round_ID),
	steam_ID decimal not null REFERENCES Players(steam_ID),
	role nvarchar(50),
	Time_in_Round time not null
);
CREATE TABLE Menu_Buys(
	round_ID int not null REFERENCES Rounds(round_ID),
	steam_ID decimal not null REFERENCES Players(steam_ID),
	item_Name nvarchar(50) not null,
	Time_in_Round time not null
);
CREATE TABLE Deaths(
	round_ID int not null REFERENCES Rounds(round_ID),
	Killer decimal null REFERENCES Players(steam_ID),
	Victum decimal not null REFERENCES Players(steam_ID),
	death_cause nvarchar(50) not null,
	Time_in_Round time not null,
	Weapon_Name int REFERENCES Items(item_ID),
);