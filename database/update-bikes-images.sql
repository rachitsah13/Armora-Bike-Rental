-- Run this on an existing armora_db database to add images and refresh the price list.
USE armora_db;

-- Skip this line if image_url column already exists:
ALTER TABLE bikes ADD COLUMN image_url VARCHAR(500) NULL AFTER price_per_hour;

INSERT INTO bikes (title, isbn_number, genre, author, price_per_hour, image_url, status) VALUES
('BMW S1000RR', 'SN-BMW-S1K', 'Superbike', 'BMW', 8000.00,
 'https://images.unsplash.com/photo-1558981403-c5f97dbbe6ad?auto=format&fit=crop&w=1200&q=80', 'AVAILABLE'),
('Ducati Panigale V4', 'SN-DUC-V4', 'Superbike', 'Ducati', 9000.00,
 'https://images.unsplash.com/photo-1568772585407-9361f9bf3a87?auto=format&fit=crop&w=1200&q=80', 'AVAILABLE'),
('Aprillia RSv4', 'SN-APR-V4', 'Superbike', 'Aprilia', 7000.00,
 'https://images.unsplash.com/photo-1591637333184-19aa84b3e01f?auto=format&fit=crop&w=1200&q=80', 'AVAILABLE'),
('Kawasaki Ninja ZX10R', 'SN-KAW-ZX10', 'Superbike', 'Kawasaki', 8000.00,
 'https://images.unsplash.com/photo-1614165939020-f71f168bd2fe?auto=format&fit=crop&w=1200&q=80', 'AVAILABLE'),
('Yamaha R1M', 'SN-YAM-R1M', 'Superbike', 'Yamaha', 8000.00,
 'https://images.unsplash.com/photo-1547480579-373950f58097?auto=format&fit=crop&w=1200&q=80', 'AVAILABLE'),
('Honda Fireblade 1000RR', 'SN-HON-CBR', 'Superbike', 'Honda', 8000.00,
 'https://images.unsplash.com/photo-1599819811279-d5ad9cccf838?auto=format&fit=crop&w=1200&q=80', 'AVAILABLE')
ON DUPLICATE KEY UPDATE
    price_per_hour = VALUES(price_per_hour),
    image_url = VALUES(image_url),
    genre = VALUES(genre),
    author = VALUES(author);
