-- Create the ecommerce database
CREATE DATABASE ecommerce;
USE ecommerce;

-- Table: brand
-- Stores brand information for products
CREATE TABLE brand (
    brand_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique brand ID
    name VARCHAR(100) NOT NULL,              -- Brand name
    description TEXT                         -- Optional brand description
);

-- Table: product_category
-- Stores product category names (e.g., electronics, fashion)
CREATE TABLE product_category (
    category_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique category ID
    name VARCHAR(100) NOT NULL,                 -- Category name
    description TEXT                            -- Optional category description
);

-- Table: product
-- Stores general product information
CREATE TABLE product (
    product_id INT AUTO_INCREMENT PRIMARY KEY,  -- Unique product ID
    name VARCHAR(150) NOT NULL,                 -- Product name
    brand_id INT,                               -- Foreign key to brand
    category_id INT,                            -- Foreign key to product_category
    base_price DECIMAL(10, 2) NOT NULL,         -- Base price before variations
    description TEXT,                           -- Product description
    FOREIGN KEY (brand_id) REFERENCES brand(brand_id),
    FOREIGN KEY (category_id) REFERENCES product_category(category_id)
);

-- Table: product_image
-- Stores image URLs or references for products
CREATE TABLE product_image (
    image_id INT AUTO_INCREMENT PRIMARY KEY,    -- Unique image ID
    product_id INT,                             -- Linked product ID
    image_url VARCHAR(255) NOT NULL,            -- URL/path of image
    alt_text VARCHAR(255),                      -- Alternative text for accessibility
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- Table: color
-- Stores color options available for products
CREATE TABLE color (
    color_id INT AUTO_INCREMENT PRIMARY KEY,    -- Unique color ID
    name VARCHAR(50) NOT NULL,                  -- Color name (e.g., Red)
    hex_code CHAR(7)                            -- HEX color code (e.g., #FF0000)
);

-- Table: size_category
-- Groups types of sizes (e.g., clothing, shoes)
CREATE TABLE size_category (
    size_category_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique size category ID
    name VARCHAR(50) NOT NULL                        -- Size category name
);

-- Table: size_option
-- Stores specific size values
CREATE TABLE size_option (
    size_id INT AUTO_INCREMENT PRIMARY KEY,          -- Unique size ID
    size_category_id INT,                            -- Linked category
    label VARCHAR(10) NOT NULL,                      -- Size label (e.g., S, M, L, 42)
    FOREIGN KEY (size_category_id) REFERENCES size_category(size_category_id)
);

-- Table: product_item
-- Represents actual purchasable variations of a product (size/color)
CREATE TABLE product_item (
    item_id INT AUTO_INCREMENT PRIMARY KEY,          -- Unique item ID
    product_id INT,                                  -- Linked product
    color_id INT,                                    -- Linked color
    size_id INT,                                     -- Linked size
    sku VARCHAR(100) UNIQUE NOT NULL,                -- Unique Stock Keeping Unit
    stock_quantity INT DEFAULT 0,                    -- Stock available
    price DECIMAL(10, 2),                            -- Price (can override base)
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (color_id) REFERENCES color(color_id),
    FOREIGN KEY (size_id) REFERENCES size_option(size_id)
);

-- Table: product_variation
-- Links a product to its different variations
CREATE TABLE product_variation (
    variation_id INT AUTO_INCREMENT PRIMARY KEY,     -- Unique variation ID
    product_id INT,                                  -- Linked product
    variation_type VARCHAR(50),                      -- Type (e.g., Size, Color)
    variation_value VARCHAR(100),                    -- Value (e.g., Medium, Red)
    FOREIGN KEY (product_id) REFERENCES product(product_id)
);

-- Table: attribute_category
-- Groups product attributes (e.g., physical, technical)
CREATE TABLE attribute_category (
    attribute_category_id INT AUTO_INCREMENT PRIMARY KEY, -- Unique ID
    name VARCHAR(100) NOT NULL                            -- Category name
);

-- Table: attribute_type
-- Defines attribute value types (text, number, boolean)
CREATE TABLE attribute_type (
    attribute_type_id INT AUTO_INCREMENT PRIMARY KEY,     -- Unique ID
    name VARCHAR(50) NOT NULL                             -- Type name
);

-- Table: product_attribute
-- Stores additional product attributes (e.g., weight, material)
CREATE TABLE product_attribute (
    attribute_id INT AUTO_INCREMENT PRIMARY KEY,          -- Unique attribute ID
    product_id INT,                                       -- Linked product
    attribute_category_id INT,                            -- Category
    attribute_type_id INT,                                -- Type of value
    name VARCHAR(100) NOT NULL,                           -- Attribute name
    value VARCHAR(255) NOT NULL,                          -- Attribute value
    FOREIGN KEY (product_id) REFERENCES product(product_id),
    FOREIGN KEY (attribute_category_id) REFERENCES attribute_category(attribute_category_id),
    FOREIGN KEY (attribute_type_id) REFERENCES attribute_type(attribute_type_id)
