
------------------------------------------------------------------------
-- Select Queries
------------------------------------------------------------------------
-- Select Query for the members page
SELECT * FROM Members;

-- Select Query for the Books page
SELECT Books.BookName, Authors.firstName, Authors.lastName FROM Books
JOIN Authors ON Books.authorID = Authors.authorID;

-- Select Query for the Authors page
SELECT * FROM Authors;

-- Select Query for the LibraryLocations page
SELECT * From LibraryLocatons;

-- Select Query for bookReservations page
SELECT Members.firstName, Members.lastName, Books.bookName, BookReservations.date, BookReservations.locationID
FROM BookReservations
JOIN Members on BookReservations.memberID = Members.memberID
JOIN Books on Books.bookID = BookReservations.bookID;

-- Select Query for BookLocations page
SELECT libraryLocations.locationName, Books.bookName
FROM BookLocations
JOIN LibraryLocations ON BookLocations.locationID = LibraryLocations.locationID
JOIN Books ON BookLocations.bookID = Books.bookID; 



------------------------------------------------------------------------
-- Insertion Queries
------------------------------------------------------------------------

-- Query to add a new Book with @ to denote variables that will
-- have data from backend programming language
INSERT INTO Books(bookName, authorID)
VALUES (@fbookName_Input, @authorID_from_dropdown_Input);

-- Query to add a new Author with @ to denote variables that will
-- have data from backend programming language
INSERT INTO Authors(firstName, lastName)
VALUES (@firstName_Input, @lastName_Input);


-- Query to add a new Book Reservation with @ to denote variables that will
-- have data from backend programming language
INSERT INTO BookReservations(memberID, bookID, locationID, date)
VALUES (@memberID_from_dropdown_Input, @bookID_from_dropdown_Input, @bookID_from_dropdown, @date_Input);

------------------------------------------------------------------------
-- Update Queries
------------------------------------------------------------------------


-- Query to update data of a Book with @ to denote variables that will
-- have data from backend programming language
UPDATE Books
SET  bookName = '@bookName_Input', authorID = '@authorID_from_dropdown_Input'
WHERE bookID = @selected_Book;

-- Query to update data of an Author with @ to denote variables that will
-- have data from backend programming language
UPDATE Authors
SET  firstName = '@firstName_Input', lastName = '@lastName_Input'
WHERE authorID = @selected_Author;


-- Query to update data of a Book Reservation with @ to denote variables that will
-- have data from backend programming language
UPDATE BookReservations
SET  memberID = '@memberID_from_dropdown_Input', bookID = '@bookID_from_dropdown_Input', locationID = '@locationID_from_dropdown_Input', date = '@date_Input'
WHERE reservationID = @selected_Reservation;


------------------------------------------------------------------------
-- Delete Queries
------------------------------------------------------------------------


-- Query to delete record of a Book with @ to denote variables that will
-- have data from backend programming language
DELETE FROM Books WHERE bookID = @selected_Book;

-- Query to delete record of an Author with @ to denote variables that will
-- have data from backend programming language
DELETE FROM Authors WHERE authorID = @selected_Author;

-- Query to delete record of a Book Reservation with @ to denote variables that will
-- have data from backend programming language
DELETE FROM BookReservations WHERE reservationID = @selected_Reservation;






