-- Create the database
CREATE DATABASE SuperRide;
GO

USE SuperRide;
GO

-- Clients table
CREATE TABLE clients (
    client_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    email NVARCHAR(255) NOT NULL UNIQUE,
    phone NVARCHAR(32),
    registration_date DATETIME DEFAULT GETDATE(),
    status NVARCHAR(32) DEFAULT 'active'
);

-- Fleet table
CREATE TABLE fleet (
    vehicle_id INT IDENTITY(1,1) PRIMARY KEY,
    vehicle_type NVARCHAR(64),
    license_plate NVARCHAR(32) UNIQUE,
    manufacturer NVARCHAR(128),
    model NVARCHAR(128),
    year INT,
    capacity INT,
    status NVARCHAR(32) DEFAULT 'active'
);

-- Drivers table
CREATE TABLE drivers (
    driver_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    phone NVARCHAR(32),
    email NVARCHAR(255),
    license_number NVARCHAR(64) UNIQUE,
    hire_date DATETIME,
    status NVARCHAR(32) DEFAULT 'active',
    vehicle_id INT NULL,
    FOREIGN KEY(vehicle_id) REFERENCES fleet(vehicle_id)
);

-- Locations table
CREATE TABLE locations (
    location_id INT IDENTITY(1,1) PRIMARY KEY,
    address NVARCHAR(255),
    city NVARCHAR(128),
    state NVARCHAR(128),
    country NVARCHAR(128),
    latitude DECIMAL(10,7),
    longitude DECIMAL(10,7)
);

-- Payments table
CREATE TABLE payments (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT,
    order_id INT,
    amount DECIMAL(18,2),
    payment_time DATETIME,
    payment_method NVARCHAR(32),
    status NVARCHAR(32),
    FOREIGN KEY(client_id) REFERENCES clients(client_id)
    -- Order FK added after orders table (to avoid circular dependency)
);

-- Orders table
CREATE TABLE orders (
    order_id INT IDENTITY(1,1) PRIMARY KEY,
    client_id INT,
    driver_id INT,
    vehicle_id INT,
    pickup_location_id INT,
    dropoff_location_id INT,
    order_time DATETIME,
    pickup_time DATETIME,
    dropoff_time DATETIME,
    status NVARCHAR(32),
    price DECIMAL(18,2),
    distance_km DECIMAL(10,2),
    payment_id INT,
    FOREIGN KEY(client_id) REFERENCES clients(client_id),
    FOREIGN KEY(driver_id) REFERENCES drivers(driver_id),
    FOREIGN KEY(vehicle_id) REFERENCES fleet(vehicle_id),
    FOREIGN KEY(pickup_location_id) REFERENCES locations(location_id),
    FOREIGN KEY(dropoff_location_id) REFERENCES locations(location_id),
    FOREIGN KEY(payment_id) REFERENCES payments(payment_id)
);

-- Now add FK to payments for order_id (to avoid circular reference)
ALTER TABLE payments
    ADD CONSTRAINT FK_payments_orders_order_id FOREIGN KEY (order_id) REFERENCES orders(order_id);

-- Feedback table
CREATE TABLE feedback (
    feedback_id INT IDENTITY(1,1) PRIMARY KEY,
    order_id INT,
    client_id INT,
    driver_id INT,
    rating INT CHECK (rating BETWEEN 1 AND 5),
    comments NVARCHAR(MAX),
    feedback_time DATETIME,
    FOREIGN KEY(order_id) REFERENCES orders(order_id),
    FOREIGN KEY(client_id) REFERENCES clients(client_id),
    FOREIGN KEY(driver_id) REFERENCES drivers(driver_id)
);

-- Driver Assignments table
CREATE TABLE driver_assignments (
    assignment_id INT IDENTITY(1,1) PRIMARY KEY,
    driver_id INT,
    vehicle_id INT,
    start_time DATETIME,
    end_time DATETIME,
    FOREIGN KEY(driver_id) REFERENCES drivers(driver_id),
    FOREIGN KEY(vehicle_id) REFERENCES fleet(vehicle_id)
);

-- Indexes for performance (sample)
CREATE INDEX idx_orders_client ON orders(client_id);
CREATE INDEX idx_orders_driver ON orders(driver_id);
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_feedback_driver ON feedback(driver_id);
