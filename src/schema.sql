CREATE TABLE User
(
    name     varchar(32)  NOT NULL,
    password varchar(255) NOT NULL,
    userId   integer      NOT NULL,
    PRIMARY KEY (userId)
);

CREATE TABLE Bidder
(
    upperLimit integer NOT NULL,
    userId     integer NOT NULL,
    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES User (userId)
);

CREATE TABLE Seller
(
    userId integer NOT NULL,
    PRIMARY KEY (userId),
    FOREIGN KEY (userId) REFERENCES User (userId)
);

CREATE TABLE Book
(
    author          varchar(128) NOT NULL,
    publicationDate date         NOT NULL,
    title           varchar(128) NOT NULL,
    ISBN            varchar(13)  NOT NULL,
    PRIMARY KEY (ISBN)
);

CREATE TABLE DigitalBook
(
    fileSize integer     NOT NULL,
    ISBN     varchar(13) NOT NULL,
    PRIMARY KEY (ISBN),
    FOREIGN KEY (ISBN) REFERENCES Book (ISBN)
);

CREATE TABLE PhysicalBook
(
    ISBN varchar(13) NOT NULL,
    primary key (ISBN),
    FOREIGN KEY (ISBN) REFERENCES Book (ISBN)
);

CREATE TABLE Auction
(
    auctionId    integer      NOT NULL,
    `condition`  varchar(128),
    description  varchar(128),
    expiration   datetime     NOT NULL,
    highestBid   integer,
    increment    integer      NOT NULL,
    initialPrice integer      NOT NULL,
    isDigital    bool         NOT NULL,
    item         varchar(13) REFERENCES Book (ISBN),
    minPrice     integer      NOT NULL,
    name         varchar(128) NOT NULL,
    sellerId     integer      NOT NULL,
    PRIMARY KEY (auctionId),
    CHECK ((isDigital = TRUE AND "condition" IS NOT NULL) OR (isDigital = FALSE AND "condition" IS NULL)),
    FOREIGN KEY (sellerId) REFERENCES Seller (userId)
);

CREATE TABLE Bid
(
    amount    integer  NOT NULL,
    auctionId integer  NOT NULL,
    bidderId  integer  NOT NULL,
    time      datetime NOT NULL,
    PRIMARY KEY (time, bidderId),
    FOREIGN KEY (bidderId) REFERENCES User (userId),
    FOREIGN KEY (auctionId) REFERENCES Auction (auctionId)
);