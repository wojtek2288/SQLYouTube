USE master
GO

if exists(select * from sysdatabases where name='pd2')
	drop database pd2
GO

CREATE DATABASE pd2
GO

USE pd2
GO

CREATE TABLE Videos(
	Video_id INT NOT NULL,
	Title VARCHAR(50) NOT NULL,
	Length TIME(7) NOT NULL,
	Creator_id INT NOT NULL,
);

CREATE TABLE Videos_Categories(
	Video_id INT NOT NULL, 
	Category_id INT NOT NULL,
);

CREATE TABLE Categories( 
	Category_id INT NOT NULL,
	Category_name VARCHAR(50) NOT NULL,
);

CREATE TABLE Creators(
	Creator_id INT NOT NULL,
	Name VARCHAR(20) NOT NULL,
	Email VARCHAR(20) NOT NULL,
);

CREATE TABLE Creator_subscription(
	Creator1_id INT NOT NULL,
	Creator2_id INT NOT NULL,
);

CREATE TABLE Creator_history(
	Creator_id INT NOT NULL,
	Video_id INT NOT NULL,
	date DATE NOT NULL
);

--indeksy

CREATE CLUSTERED INDEX PK_Videos_new_key
ON Videos(Title)
GO

CREATE INDEX PK_Creator_history
ON Creator_history(date)
GO

CREATE CLUSTERED INDEX PK_Videos_Categories_new_key
ON Videos_Categories(Category_id)
GO

CREATE CLUSTERED INDEX PK_Creators_new_key
ON Creators(name)
GO

--klucze glowne

ALTER TABLE Videos
ADD 
	CONSTRAINT PK_Videos_key PRIMARY KEY(Video_id)
GO

ALTER TABLE Categories
ADD 
	CONSTRAINT PK_Categories_key PRIMARY KEY(Category_id)
GO

ALTER TABLE Videos_Categories
ADD 
	CONSTRAINT PK_Videos_Categories_key PRIMARY KEY(Video_id, Category_id)
GO

ALTER TABLE Creators
ADD 
	CONSTRAINT PK_Creators_key PRIMARY KEY(Creator_id)
GO

ALTER TABLE Creator_subscription
ADD 
	CONSTRAINT PK_Creator_subscription_key PRIMARY KEY(Creator1_id, Creator2_id)
GO

ALTER TABLE Creator_history
ADD 
	CONSTRAINT PK_Creator_history_key PRIMARY KEY(Creator_id, Video_id)
GO

--klucze obce i relacje

ALTER TABLE Videos
ADD 
	CONSTRAINT FK_Videos_Creators FOREIGN KEY (Creator_id) REFERENCES Creators(Creator_id)
GO

ALTER TABLE Videos_Categories
ADD 
	CONSTRAINT FK_Videos_Categories_Videos FOREIGN KEY (Video_id) REFERENCES Videos(Video_id),
	CONSTRAINT FK_Videos_Categories_Categories FOREIGN KEY (Category_id) REFERENCES Categories(Category_id)
GO

ALTER TABLE Creator_subscription
ADD 
	CONSTRAINT FK_Creator_subscription_Creators1 FOREIGN KEY (Creator1_id) REFERENCES Creators(Creator_id),
	CONSTRAINT FK_Creator_subscription_Creators2 FOREIGN KEY (Creator2_id) REFERENCES Creators(Creator_id)
GO

ALTER TABLE Creator_history
ADD 
	CONSTRAINT FK_Creator_history_Creators FOREIGN KEY (Creator_id) REFERENCES Creators(Creator_id),
	CONSTRAINT FK_Creator_history_Videos FOREIGN KEY (Video_id) REFERENCES Videos(Video_id)
GO