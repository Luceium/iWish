
-- Users table
CREATE TABLE IF NOT EXISTS Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    PasswordHash VARCHAR(255) NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO Users (Username, Email, PasswordHash) VALUES 
('Alice', 'alice@example.com', 'hashed_password_1'),
('Bob', 'bob@example.com', 'hashed_password_2'),
('Charlie', 'charlie@example.com', 'hashed_password_3'),
('David', 'david@example.com', 'hashed_password_4'),
('Eve', 'eve@example.com', 'hashed_password_5');

-- Wishlists table
CREATE TABLE IF NOT EXISTS Wishlists (
    WishlistID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    Title VARCHAR(100) NOT NULL,
    Description TEXT,
    Visibility ENUM('Public', 'Private', 'Shared') NOT NULL DEFAULT 'Private',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

INSERT INTO Wishlists (UserID, Title, Description, Visibility) VALUES 
(1, 'Christmas Wishlist', 'A list of items for Christmas', 'Public'),
(1, 'Birthday Wishlist', 'Items I want for my birthday', 'Private'),
(2, 'Vacation Wishlist', 'Things to bring for vacation', 'Shared'),
(3, 'Home Decor Wishlist', 'Items for decorating my home', 'Public'),
(4, 'Tech Wishlist', 'Latest tech gadgets I want', 'Private');

-- Items table
CREATE TABLE IF NOT EXISTS Items (
    ItemID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2),
    URL VARCHAR(255)
);

INSERT INTO Items (Name, Description, Price, URL) VALUES 
('Bluetooth Headphones', 'High-quality wireless headphones', 99.99, 'http://example.com/headphones'),
('Smart Watch', 'Track your fitness and health', 199.99, 'http://example.com/smartwatch'),
('Gaming Mouse', 'Precision mouse for gaming', 49.99, 'http://example.com/mouse'),
('Laptop Stand', 'Ergonomic stand for laptops', 29.99, 'http://example.com/stand'),
('Wireless Charger', 'Fast wireless charging pad', 25.99, 'http://example.com/charger');

-- WishlistItems table
CREATE TABLE IF NOT EXISTS WishlistItems (
    WishlistID INT,
    ItemID INT,
    Quantity INT DEFAULT 1,
    IdealAmount DECIMAL(10, 2),
    AddedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (WishlistID, ItemID),
    FOREIGN KEY (WishlistID) REFERENCES Wishlists(WishlistID),
    FOREIGN KEY (ItemID) REFERENCES Items(ItemID)
);

INSERT INTO WishlistItems (WishlistID, ItemID, Quantity, IdealAmount) VALUES 
(1, 1, 1, 89.99),
(1, 2, 1, 199.99),
(2, 1, 1, 79.99),
(2, 3, 1, 45.99),
(3, 4, 2, 59.98);

-- GiftExchanges table
CREATE TABLE IF NOT EXISTS GiftExchanges (
    ExchangeID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Description TEXT,
    CreatedByUserID INT NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ExchangeDate DATE,
    FOREIGN KEY (CreatedByUserID) REFERENCES Users(UserID)
);

INSERT INTO GiftExchanges (Name, Description, CreatedByUserID) VALUES 
('Christmas Exchange', 'A fun exchange for Christmas gifts', 1),
('Secret Santa', 'Anonymous gift exchange among friends', 2),
('Birthday Bash', 'Gift exchange for my birthday', 3);

-- ExchangeParticipants table
CREATE TABLE IF NOT EXISTS ExchangeParticipants (
    ExchangeID INT,
    UserID INT,
    WishlistID INT,
    JoinedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ExchangeID, UserID),
    FOREIGN KEY (ExchangeID) REFERENCES GiftExchanges(ExchangeID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (WishlistID) REFERENCES Wishlists(WishlistID)
);

INSERT INTO ExchangeParticipants (ExchangeID, UserID, WishlistID) VALUES 
(1, 1, 1),  -- User 1 joins Exchange 1 with Wishlist 1
(1, 2, 2),  -- User 2 joins Exchange 1 with Wishlist 2
(2, 1, 3),  -- User 1 joins Exchange 2 with Wishlist 3
(2, 3, 4);  -- User 3 joins Exchange 2 with Wishlist 4

-- ExchangeAssignments table
CREATE TABLE IF NOT EXISTS ExchangeAssignments (
    ExchangeID INT,
    GiverUserID INT,
    RecipientUserID INT,
    AssignedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ExchangeID, GiverUserID),
    FOREIGN KEY (ExchangeID) REFERENCES GiftExchanges(ExchangeID),
    FOREIGN KEY (GiverUserID) REFERENCES Users(UserID),
    FOREIGN KEY (RecipientUserID) REFERENCES Users(UserID),
    CONSTRAINT unique_recipient_per_exchange UNIQUE (ExchangeID, RecipientUserID)
);

INSERT INTO ExchangeAssignments (ExchangeID, GiverUserID, RecipientUserID) VALUES 
(1, 1, 2),  -- In Exchange 1, User 1 gives to User 2
(1, 2, 1),  -- In Exchange 1, User 2 gives to User 1
(2, 1, 3),  -- In Exchange 2, User 1 gives to User 3
(2, 3, 1);  -- In Exchange 2, User 3 gives to User 1

-- UserFriendships table
CREATE TABLE IF NOT EXISTS UserFriendships (
    UserID INT,
    FriendID INT,
    FriendshipStatus ENUM('Pending', 'Accepted', 'Blocked') NOT NULL,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (UserID, FriendID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (FriendID) REFERENCES Users(UserID),
    CHECK (UserID < FriendID)
);

-- Insert friendship data
INSERT INTO UserFriendships (UserID, FriendID, FriendshipStatus) VALUES
(1, 2, 'Accepted'),  -- Alice and Bob are friends
(1, 3, 'Accepted'),  -- Alice and Charlie are friends
(2, 4, 'Pending'),   -- Bob sent a friend request to David
(3, 5, 'Accepted'),  -- Charlie and Eve are friends
(4, 5, 'Blocked');   -- David blocked Eve

-- Transactions are shown in GiftExchange, user can choose either to show or hide them on the feed. This can also be used by user to view all their past transactions
CREATE TABLE IF NOT EXISTS Transactions (
    TransactionID INTEGER PRIMARY KEY AUTO_INCREMENT,
    ExchangeID INTEGER NOT NULL,
    GiverUserID INTEGER NOT NULL,
    ReceiverUserID INTEGER NOT NULL,
    WishlistID INTEGER NOT NULL,
    ItemID INTEGER NOT NULL,
    TransactionDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    IsPrivate BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (ExchangeID) REFERENCES GiftExchanges(ExchangeID),
    FOREIGN KEY (GiverUserID) REFERENCES Users(UserID),
    FOREIGN KEY (ReceiverUserID) REFERENCES Users(UserID),
    FOREIGN KEY (WishlistID, ItemID) REFERENCES WishlistItems(WishlistID, ItemID)
);

INSERT INTO Transactions (ExchangeID, GiverUserID, ReceiverUserID, WishlistID, ItemID, IsPrivate) VALUES 
(1, 2, 1, 1, 1, FALSE),  -- In Exchange 1, User 2 gave Item 1 from Wishlist 1 to User 1 (Public)
(1, 1, 3, 1, 2, TRUE),   -- In Exchange 1, User 1 gave Item 2 from Wishlist 1 to User 3 (Private)
(2, 3, 4, 2, 3, FALSE);  -- In Exchange 2, User 3 gave Item 3 from Wishlist 2 to User 4 (Public)


-- Create ExchangeFeed table
CREATE TABLE IF NOT EXISTS ExchangeFeed (
    FeedID INTEGER PRIMARY KEY AUTO_INCREMENT,
    ExchangeID INTEGER NOT NULL,
    FOREIGN KEY (ExchangeID) REFERENCES GiftExchanges(ExchangeID)
);

INSERT INTO ExchangeFeed (ExchangeID) VALUES 
(1),  -- Christmas Exchange
(2),  -- Secret Santa
(3);  -- Birthday Bash

-- Create FeedItems table
CREATE TABLE IF NOT EXISTS FeedItems (
    FeedID INTEGER,
    ItemID INTEGER,
    PRIMARY KEY (FeedID, ItemID),
    FOREIGN KEY (FeedID) REFERENCES ExchangeFeed(FeedID),
    FOREIGN KEY (ItemID) REFERENCES WishlistItems(ItemID)
);

-- When implementing, when user adds an item to a wishlist. Check if wishlist is public/private. Check exchanges with that specific wishlist. If exists, add itemID to the feed to display.
-- Assuming each WishlistItem is added to the feed of the corresponding exchange
INSERT INTO FeedItems (FeedID, ItemID)
SELECT 
    CASE 
        WHEN wi.WishlistID = 1 THEN 1  -- Items from Wishlist 1 go to Exchange 1 (Christmas Exchange)
        WHEN wi.WishlistID = 2 THEN 2  -- Items from Wishlist 2 go to Exchange 2 (Secret Santa)
        WHEN wi.WishlistID = 3 THEN 3  -- Items from Wishlist 3 go to Exchange 3 (Birthday Bash)
    END AS FeedID,
    wi.ItemID
FROM WishlistItems wi;
