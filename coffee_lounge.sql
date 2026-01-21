-- Create database
CREATE DATABASE IF NOT EXISTS coffee_lounge_db;
USE coffee_lounge_db;

-- Users table for admin authentication
CREATE TABLE users (
    id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL,
    role ENUM('admin', 'manager', 'staff') DEFAULT 'staff',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP NULL,
    is_active BOOLEAN DEFAULT TRUE
);

-- Menu categories table
CREATE TABLE menu_categories (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    icon VARCHAR(50) NOT NULL,
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Menu items table
CREATE TABLE menu_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    is_special BOOLEAN DEFAULT FALSE,
    is_available BOOLEAN DEFAULT TRUE,
    display_order INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES menu_categories(id) ON DELETE CASCADE
);

-- Testimonials table
CREATE TABLE testimonials (
    id INT PRIMARY KEY AUTO_INCREMENT,
    customer_name VARCHAR(100) NOT NULL,
    customer_title VARCHAR(200),
    rating DECIMAL(3,1) NOT NULL CHECK (rating >= 0 AND rating <= 5),
    testimonial_text TEXT NOT NULL,
    icon_class VARCHAR(50) DEFAULT 'fas fa-user',
    is_approved BOOLEAN DEFAULT TRUE,
    is_featured BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Gallery items table
CREATE TABLE gallery_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    category VARCHAR(50) NOT NULL,
    image_url VARCHAR(500) NOT NULL,
    alt_text VARCHAR(200) NOT NULL,
    title VARCHAR(200) NOT NULL,
    display_order INT DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Contact messages table
CREATE TABLE contact_messages (
    id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    ip_address VARCHAR(45),
    user_agent TEXT,
    status ENUM('unread', 'read', 'replied', 'archived') DEFAULT 'unread',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    replied_at TIMESTAMP NULL,
    admin_notes TEXT
);

-- Orders table (if you want to accept online orders)
CREATE TABLE orders (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_number VARCHAR(20) UNIQUE NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    customer_phone VARCHAR(20) NOT NULL,
    customer_email VARCHAR(100),
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'preparing', 'ready', 'delivered', 'cancelled') DEFAULT 'pending',
    payment_method ENUM('cash', 'card', 'online') DEFAULT 'cash',
    payment_status ENUM('pending', 'paid', 'refunded') DEFAULT 'pending',
    delivery_type ENUM('pickup', 'delivery') DEFAULT 'pickup',
    delivery_address TEXT,
    special_instructions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Order items table
CREATE TABLE order_items (
    id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    menu_item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(id) ON DELETE CASCADE,
    FOREIGN KEY (menu_item_id) REFERENCES menu_items(id) ON DELETE SET NULL
);

-- Settings table
CREATE TABLE settings (
    id INT PRIMARY KEY AUTO_INCREMENT,
    setting_key VARCHAR(100) UNIQUE NOT NULL,
    setting_value TEXT NOT NULL,
    setting_type ENUM('text', 'number', 'boolean', 'json') DEFAULT 'text',
    description VARCHAR(255),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Insert default admin user (password: Admin@123)
INSERT INTO users (username, password, email, role) VALUES 
('admin', '$2y$10$YourHashedPasswordHere', 'admin@coffeelounge.com', 'admin');

-- Insert default menu categories
INSERT INTO menu_categories (name, icon, display_order) VALUES
('Hot Beverages', 'fas fa-fire', 1),
('Cold Beverages', 'fas fa-snowflake', 2),
('Smoothies', 'fas fa-blender', 3),
('Special Cocktails', 'fas fa-cocktail', 4),
('Ice Cream & Shakes', 'fas fa-ice-cream', 5),
('Frozen Yogurt & Granita', 'fas fa-wind', 6);

-- Insert default menu items
INSERT INTO menu_items (category_id, name, price, is_special) VALUES
(1, 'Coffee', 3.50, FALSE),
(1, 'Espresso', 2.80, FALSE),
(1, 'Cappuccino', 4.20, TRUE),
(1, 'Latte', 4.50, TRUE),
(1, 'Hot Chocolate', 3.80, FALSE),
(2, 'Iced Coffee', 4.00, FALSE),
(2, 'Cold Brew', 4.50, TRUE),
(2, 'Iced Tea', 3.25, FALSE),
(2, 'Lemonade', 3.50, FALSE),
(3, 'Berry Blast', 5.50, TRUE),
(3, 'Tropical Mango', 5.75, FALSE),
(3, 'Green Detox', 6.00, TRUE),
(3, 'Strawberry Banana', 5.25, FALSE),
(4, 'Espresso Martini', 9.50, TRUE),
(4, 'Coffee Old Fashioned', 10.00, TRUE),
(4, 'Irish Coffee', 8.75, TRUE),
(5, 'Chocolate Shake', 5.50, FALSE),
(5, 'Vanilla Malt', 5.25, FALSE),
(5, 'Strawberry Shake', 5.75, FALSE),
(6, 'Strawberry Frozen Yogurt', 4.75, FALSE),
(6, 'Coffee Granita', 4.50, FALSE),
(6, 'Mixed Berry Granita', 4.75, FALSE);

-- Insert default testimonials
INSERT INTO testimonials (customer_name, customer_title, rating, testimonial_text, icon_class, is_featured) VALUES
('Abid Ahmad', 'Lecturer at Southeast University', 4.5, 'The quality of coffee here is exceptional! As someone who appreciates fine coffee, I must say this place exceeds expectations. Perfect place for academic discussions!', 'fas fa-user-graduate', TRUE),
('Md. Mahi Uddin', 'Department of CSE at Southeast University', 4.0, 'I tried the new coffee and it was amazing! The aroma and flavor are exceptional. Will definitely come back for more!', 'fas fa-user', TRUE),
('Enamul Huq', NULL, 4.5, 'The coffee is excellent! I''ve been coming here for months and the quality is always consistent. The staff is friendly too!', 'fas fa-user', TRUE),
('Faisal', NULL, 3.0, 'Absolutely love the atmosphere here. The coffee is perfect and the pastries are fresh. My go-to spot for morning coffee!', 'fas fa-user', FALSE),
('Ahsan Habib Shakil', NULL, 4.0, 'The coffee here is perfect. The taste is just right, not too bitter and not too mild. The ambiance makes it even better!', 'fas fa-user', TRUE),
('Tanjina Hossain', NULL, 5.0, 'Best coffee place in town! I''m a regular here and I always recommend it to my friends. The service is outstanding!', 'fas fa-user', TRUE);

-- Insert default gallery items
INSERT INTO gallery_items (category, image_url, alt_text, title) VALUES
('hot', 'https://images.unsplash.com/photo-1511537190424-bbbab87ac5eb?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80', 'Coffee', 'Coffee'),
('cold', 'https://images.unsplash.com/photo-1563227812-0ea4c22e6cc8?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80', 'Iced Tea', 'Iced Tea'),
('smoothies', 'https://images.pexels.com/photos/103566/pexels-photo-103566.jpeg', 'Smoothie Bowl', 'Smoothie Bowl'),
('smoothies', 'https://images.pexels.com/photos/1128678/pexels-photo-1128678.jpeg', 'Tropical Smoothie', 'Tropical Smoothie'),
('juice', 'https://images.pexels.com/photos/128242/pexels-photo-128242.jpeg', 'Fresh Juice', 'Fresh Juice'),
('cocktails', 'https://images.unsplash.com/photo-1514362545857-3bc16c4c7d1b?ixlib=rb-4.0.3&auto=format&fit=crop&w=1470&q=80', 'Cocktails', 'Cocktails'),
('snacks', 'https://images.pexels.com/photos/1639562/pexels-photo-1639562.jpeg', 'Burger', 'Burger');

-- Insert default settings
INSERT INTO settings (setting_key, setting_value, description) VALUES
('site_name', 'Coffee Lounge', 'Website name'),
('site_email', 'mahiuddin9685@gmail.com', 'Contact email'),
('site_phone', '01865087085', 'Contact phone'),
('site_address', '03 number road Mohanagar project, Dhaka, Bangladesh', 'Physical address'),
('opening_hours', '{"mon_fri":"7am - 9pm","saturday":"8am - 10pm","sunday":"8am - 8pm"}', 'Opening hours in JSON format'),
('social_facebook', '#', 'Facebook URL'),
('social_instagram', '#', 'Instagram URL'),
('social_twitter', '#', 'Twitter URL'),
('social_youtube', '#', 'YouTube URL'),
('about_text', 'At Coffee Lounge in Barnet, we pride ourselves on being a go-to destination for coffee lovers and connoisseurs seeking a delightful experience in every cup. We offer a wide range of coffee, teas, and snacks, ensuring that there''s something for everyone.', 'About us text');

-- Create indexes for better performance
CREATE INDEX idx_menu_items_category ON menu_items(category_id);
CREATE INDEX idx_testimonials_approved ON testimonials(is_approved, is_featured);
CREATE INDEX idx_gallery_active ON gallery_items(is_active, display_order);
CREATE INDEX idx_contact_status ON contact_messages(status, created_at);