-- Group 25  Pablo Garza & Gino Febles
-- Good Place Library

SET FOREIGN_KEY_CHECKS=0;
SET AUTOCOMMIT = 0;
DROP TABLE IF EXISTS Members, Authors, Books, BookReservations, LibraryLocations, BookLocations;

-- -----------------------------------------------------
-- Table Members
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Members (
   memberID INT NOT NULL AUTO_INCREMENT,
   firstName VARCHAR(255) NOT NULL,
   lastName VARCHAR(255) NOT NULL,
   phoneNumber VARCHAR(255) NOT NULL,
   email VARCHAR(225) NOT NULL,
	PRIMARY KEY (memberID),
    UNIQUE (firstName, lastName)
  );

-- -----------------------------------------------------
-- Table Authors
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Authors (
  authorID INT NOT NULL AUTO_INCREMENT,
  firstName VARCHAR(255) NOT NULL,
  lastName VARCHAR(255) NOT NULL,
  PRIMARY KEY (authorID)
  );

-- -----------------------------------------------------
-- Table Books
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS Books (
  bookID INT NOT NULL AUTO_INCREMENT,
  bookName VARCHAR(255) NOT NULL,
  authorID INT NOT NULL,
  FOREIGN KEY (authorID) REFERENCES Authors(authorID) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (bookID),
  UNIQUE (bookName)
  );
  
-- -----------------------------------------------------
-- Table LibraryLocations
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS LibraryLocations (
   locationID INT NOT NULL AUTO_INCREMENT,
   locationName VARCHAR(255) NOT NULL,
   locationAddress VARCHAR(255) NOT NULL,
   locationPhone  VARCHAR(255) NOT NULL,
   locationEmail VARCHAR(225) NOT NULL,
   PRIMARY KEY (locationID)
  );
  
-- -----------------------------------------------------
-- Table BookReservations
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS BookReservations (
  reservationID INT NOT NULL AUTO_INCREMENT,
  memberID INT NOT NULL,
  bookID INT NOT NULL,
  locationID INT NOT NULL,
  date DATE NULL, 
  UNIQUE (bookID, date),
  FOREIGN KEY (memberID) REFERENCES Members(memberID) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY(bookID) REFERENCES Books(bookID)ON DELETE CASCADE ON UPDATE CASCADE,  
  FOREIGN KEY (locationID) REFERENCES LibraryLocations(locationID) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (reservationID)
);


-- -----------------------------------------------------
-- Table BookLocations
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS BookLocations (
  locationID INT NOT NULL,
  bookID INT NOT NULL,
  PRIMARY KEY (locationID, bookID),
  UNIQUE (bookID),
  FOREIGN KEY (locationID) REFERENCES LibraryLocations(locationID) ON DELETE CASCADE,
  FOREIGN KEY(bookID) REFERENCES Books(bookID) ON DELETE CASCADE
 );

SET FOREIGN_KEY_CHECKS=1;
COMMIT;

-- -----------------------------------------------------
-- Insert Section
-- -----------------------------------------------------

-- Insert Members
INSERT INTO Members (firstName, lastName, phoneNumber, email)
VALUES
	("Pablo", "Garza", "3475752523", "pg@email.com"),
    ("Mike", "Johnson", "1546345967", "mike.j@gmail.com"),
    ("Daiana", "Bell", "4593845731", "daiana.34@hotmail.com"),
    ("Jessie", "Owens", "5738457362", "j.ownes@yahoo.com");


 -- Insert Authors
INSERT INTO Authors (firstName, lastName)
VALUES 
	("Gabriel", "Garcia"),
	("Malcolm", "Gladwell"),
	("Ernst", "Hemingway");
  
  
    -- Insert Books
INSERT INTO Books (bookName, authorID)
VALUES
	("100 Years of Solitude", (SELECT authorID FROM Authors where firstName = "Gabriel" AND lastName = "Garcia")),
    ("Blink", (SELECT authorID FROM Authors where firstName = "Malcolm" AND lastName = "Gladwell")),
    ("Until August", (SELECT authorID FROM Authors where firstName = "Gabriel" AND lastName = "Garcia"));
    
 
    -- Insert LibraryLocations
INSERT INTO LibraryLocations (locationName, locationAddress, locationPhone, locationEmail)
VALUES
	("Books For All", "324 Parkside CT", "4155550132", "books4all@thelibrary.com"),
	("Vintage Books", "125 Starr St", "2125550198", "vintagebooks@thelibrary.com"),
	("Ferris Road Library", "45 Ferris Rd", "3105550175", "ferrisrd@thelibrary.com");
    
    
    -- Mike Johnson reserves "100 Years of Solitude" at Ferris Road Library
INSERT INTO BookReservations (memberID, bookID, locationID, date)
SELECT m.memberID, b.bookID, l.locationID, '2025-05-28'
FROM Members m
JOIN Books b ON b.bookName = '100 Years of Solitude'
JOIN LibraryLocations l ON l.locationName = 'Ferris Road Library'
WHERE m.firstName = 'Mike' AND m.lastName = 'Johnson';

-- Daiana Bell reserves "Blink" at Books For All
INSERT INTO BookReservations (memberID, bookID, locationID, date)
SELECT m.memberID, b.bookID, l.locationID, '2025-06-03'
FROM Members m
JOIN Books b ON b.bookName = 'Blink'
JOIN LibraryLocations l ON l.locationName = 'Books For All'
WHERE m.firstName = 'Daiana' AND m.lastName = 'Bell';

-- Mike Johnson reserves "Until August" at Vintage Books
INSERT INTO BookReservations (memberID, bookID, locationID, date)
SELECT m.memberID, b.bookID, l.locationID, '2025-06-07'
FROM Members m
JOIN Books b ON b.bookName = 'Until August'
JOIN LibraryLocations l ON l.locationName = 'Vintage Books'
WHERE m.firstName = 'Mike' AND m.lastName = 'Johnson';

-- Pablo Garza reserves "100 Years of Solitude" at Ferris Road Library
INSERT INTO BookReservations (memberID, bookID, locationID, date)
SELECT m.memberID, b.bookID, l.locationID, '2025-07-12'
FROM Members m
JOIN Books b ON b.bookName = '100 Years of Solitude'
JOIN LibraryLocations l ON l.locationName = 'Ferris Road Library'
WHERE m.firstName = 'Pablo' AND m.lastName = 'Garza';

    
	-- Insert BookLocations
INSERT INTO BookLocations (locationID, bookID)
VALUES
	((SELECT locationID from LibraryLocations where locationName = "Books For All"),
    (SELECT bookID from Books where bookName = "Blink")),
    
	((SELECT locationID from LibraryLocations where locationName = "Vintage Books"),
    (SELECT bookID from Books where bookName = "Until August")),
    
	((SELECT locationID from LibraryLocations where locationName = "Ferris Road Library"),
    (SELECT bookID from Books where bookName = "100 Years of Solitude"));
    
    
    
    

