
-- SQL Script to Create Tables for Wishlist Application

-- Users Table
CREATE TABLE users (
    id UUID PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(100)
);

-- Friends Table
CREATE TABLE friends (
    user_id_1 UUID REFERENCES users(id),
    user_id_2 UUID REFERENCES users(id),
    status ENUM('pending', 'accepted', 'declined'),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id_1, user_id_2)
);

-- Privacy Groups Table
CREATE TABLE privacy_groups (
    id UUID PRIMARY KEY,
    owner_id UUID REFERENCES users(id),
    name VARCHAR(50)
);

-- Privacy Group Members Table
CREATE TABLE privacy_group_members (
    privacy_group_id UUID REFERENCES privacy_groups(id),
    member_id UUID REFERENCES users(id),
    PRIMARY KEY (privacy_group_id, member_id)
);

-- Wishlists Table
CREATE TABLE wishlists (
    id UUID PRIMARY KEY,
    title VARCHAR(100),
    description TEXT,
    owner_id UUID REFERENCES users(id),
    privacy_group_id UUID REFERENCES privacy_groups(id)
);

-- Wishlist Items Table
CREATE TABLE items (
    id UUID PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT NOT NULL,
    price DECIMAL,
    url VARCHAR(255),
    image_url VARCHAR(255),
    wishlist_id UUID REFERENCES wishlists(id),
    privacy_group_id UUID REFERENCES privacy_groups(id),
    reserved_by UUID REFERENCES users(id),
    suggested_by UUID REFERENCES users(id)
);

-- Events Table
CREATE TABLE events (
    id UUID PRIMARY KEY,
    title VARCHAR(100),
    description TEXT,
    event_type ENUM('random', 'birthday'),
    target_user_id UUID REFERENCES users(id),
    created_by UUID REFERENCES users(id),
    start_date DATE,
    end_date DATE,
    budget DECIMAL
);

-- Event Participants Table
CREATE TABLE event_participants (
    event_id UUID REFERENCES events(id),
    user_id UUID REFERENCES users(id),
    status ENUM('invited', 'accepted', 'declined'),
    PRIMARY KEY (event_id, user_id)
);

-- Event Assignments Table
CREATE TABLE event_assignments (
    event_id UUID REFERENCES events(id),
    assigned_user_id UUID REFERENCES users(id),
    assignee_id UUID REFERENCES users(id),
    assigned_wishlist_id UUID REFERENCES wishlists(id),
    PRIMARY KEY (event_id, assigned_user_id, assignee_id)
);

-- Transactions Table
CREATE TABLE transactions (
    id UUID PRIMARY KEY,
    buyer_id UUID REFERENCES users(id),
    recipient_id UUID REFERENCES users(id),
    item_id UUID REFERENCES items(id),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
