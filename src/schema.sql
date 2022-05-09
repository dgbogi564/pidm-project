CREATE DATABASE  IF NOT EXISTS `BuyMe`;
USE `BuyMe`;

CREATE TABLE User
(
    name     varchar(32)  NOT NULL,
    password varchar(255) NOT NULL,
    userId   integer      NOT NULL,
    PRIMARY KEY (userId)
);

CREATE TABLE Admin
(
    userId integer NOT NULL,
    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES User (userId)
);

CREATE TABLE Representative
(
    userId integer NOT NULL,
    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES User (userId)
);

CREATE TABLE Regular
(
    userId integer NOT NULL,
    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES User (userId)
);

CREATE TABLE Clothes
(
    name         varchar(128) NOT NULL,
    manufacturer varchar(128) NOT NULL,
    color        varchar(128) NOT NULL,
    `condition`  varchar(128) NOT NULL,
    itemId       integer      NOT NULL,
    PRIMARY KEY (itemId)
);

CREATE TABLE Shirts
(
    armLength  float   NOT NULL,
    collarSize float   NOT NULL,
    waistSize  float   NOT NULL,
    itemId     integer NOT NULL,
    PRIMARY KEY (itemId),
    FOREIGN KEY (itemId) REFERENCES Clothes (itemId)
);

CREATE TABLE Pants
(
    width  float   NOT NULL,
    length float   NOT NULL,
    itemId integer NOT NULL,
    PRIMARY KEY (itemId),
    FOREIGN KEY (itemId) REFERENCES Clothes (itemId)
);

CREATE TABLE Shoes
(
    size   float   NOT NULL,
    itemId integer NOT NULL,
    PRIMARY KEY (itemId),
    FOREIGN KEY (itemId) REFERENCES Clothes (itemId)
);

CREATE TABLE Auction
(
    title        varchar(128) NOT NULL,
    description  varchar(128),
    itemId       integer      NOT NULL REFERENCES Clothes (itemId),
    quantity     integer      NOT NULL,
    expiration   datetime     NOT NULL,
    initialPrice float        NOT NULL,
    minPrice     float        NOT NULL,
    increment    float        NOT NULL,
    highestBid   float,
    auctionId    integer      NOT NULL,
    sellerId     integer      NOT NULL,
    PRIMARY KEY (auctionId),
    FOREIGN KEY (sellerId) REFERENCES Regular (userId)
);

CREATE TABLE Bid
(
    amount    integer  NOT NULL,
    time      datetime NOT NULL,
    anonymous bool     NOT NULL,
    auctionId integer  NOT NULL,
    bidderId  integer  NOT NULL,
    PRIMARY KEY (amount, bidderId),
    FOREIGN KEY (bidderId) REFERENCES User (userId),
    FOREIGN KEY (auctionId) REFERENCES Auction (auctionId)
);

CREATE TABLE Participates
(
    upperLimit float   NOT NULL,
    userId     integer NOT NULL,
    auctionId  integer NOT NULL,
    PRIMARY KEY (userId, auctionId),
    FOREIGN KEY (userId) REFERENCES User (userId),
    FOREIGN KEY (auctionId) REFERENCES Auction (auctionId)
);

CREATE TABLE AuctionAlert
(
    titleKeywords		varchar(256),
	descriptionKeywords	varchar(256),
	color				varchar(128),
	manufacturer		varchar(128),
	minBid				float,
	maxBid				float,
	alertId				integer			NOT NULL,
	userId				integer			NOT NULL,
	PRIMARY KEY (userId, alertId),
	FOREIGN KEY (userId) REFERENCES User (userId)
);

CREATE TABLE BidAlert
(
	userId integer NOT NULL,
    auctionId integer NOT NULL,
    PRIMARY KEY (userId, auctionId),
    FOREIGN KEY (userId) REFERENCES User (userId),
    FOREIGN KEY (auctionId) REFERENCES Auction (auctionId)
);

INSERT INTO User(name, password, userId)
VALUES('admin', 'admin', 1);
INSERT INTO Admin(userId)
VALUES (1);