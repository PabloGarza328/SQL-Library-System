

/*   SETUP
*/

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));             // We need to instantiate an express object to interact with the server in our code
const PORT = 8011;     // Set a port number

// Database 
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

/*
    ROUTES
*/
// READ ROUTES
app.get('/', async function (req, res) {
    try {
        res.render('home'); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});


app.get('/members', async (req, res) => {
     try {
  const [rows] = await db.query('SELECT * FROM Members');
  res.render('members', { members: rows });
      } catch (err) {
 res.status(500).send('Database error');
 }
});


app.get('/books', async (req, res) => {
  try {
    const [rows] = await db.query(`
      SELECT 
        Books.bookID, 
        Books.bookName, 
        Authors.firstName AS authorFirstName, 
        Authors.lastName AS authorLastName
      FROM Books
      JOIN Authors ON Books.authorID = Authors.authorID
    `);

    res.render('books', { books: rows });
  } catch (err) {
    console.error('Error fetching books:', err);
    res.status(500).send('Database error while retrieving books.');
  }
});



app.get('/authors', async (req, res) => {
  try {
    const [rows] = await db.query('SELECT * FROM Authors');
    res.render('authors', { authors: rows });
  } catch (err) {
    console.error('Error fetching authors:', err);
    res.status(500).send('Database error while retrieving authors.');
  }
});

app.get('/locations', async (req, res) => {
     try {
  const [rows] = await db.query('SELECT * FROM LibraryLocations');
  res.render('locations', { locations: rows });
      } catch (err) {
 res.status(500).send('Database error');
 }
});

// Assuming you're using Express and a MySQL connection
app.get('/booklocations', async (req, res) => {
  const query = `
    SELECT 
      bl.bookID, 
      b.bookName, 
      bl.locationID, 
      l.locationName
    FROM BookLocations bl
    JOIN Books b ON bl.bookID = b.bookID
    JOIN LibraryLocations l ON bl.locationID = l.locationID
  `;

  try {
    const [rows] = await db.execute(query);
    res.render('booklocations', { booklocations: rows });
  } catch (err) {
    console.error(err);
    res.status(500).send('Database error');
  }
});

/* Citation for the following code:
-- Date: May 19th
-- Based off chat gpt prompt
-- Source URL: www.chatgpt.com
-- If AI tools were used:
-- Prompt 'Help me fix the code for book reservations
*/

app.get('/reservations', async (req, res) => {
  const query = `
    SELECT 
      r.reservationID,
      CONCAT(m.firstName, ' ', m.lastName) AS memberName,
      b.bookName,
      l.locationName,
      r.date
    FROM BookReservations r
    JOIN Members m ON r.memberID = m.memberID
    JOIN Books b ON r.bookID = b.bookID
    JOIN LibraryLocations l ON r.locationID = l.locationID
    ORDER BY r.date;
  `;

  try {
    const [rows] = await db.execute(query);
    res.render('reservations', { reservations: rows });
  } catch (err) {
    console.error('Error fetching reservations:', err);
    res.status(500).send('Error loading reservations');
  }
});

// DELETE ROUTE for Members
app.post('/members/delete', async function (req, res) {
    try {
        // Parse frontend form information
        let data = req.body;

        // Create and execute the stored procedure call
        const query = `CALL sp_delete_member(?);`;
        await db.query(query, [data.delete_person_id]);

        console.log(`DELETE Members. ID: ${data.delete_person_id} ` +
            `Name: ${data.delete_person_name}`
        );

        // Redirect to the updated members page
        res.redirect('/members');
    } catch (error) {
        console.error('Error executing delete procedure:', error);
        res.status(500).send(
            'An error occurred while deleting the member.'
        );
    }
});

/* Citation for the following code:
-- Date: May 19th
-- Based off chat gpt prompt
-- Source URL: www.chatgpt.com
-- If AI tools were used:
-- Prompt 'Hod do i handle a post request to load-library-db
*/

app.post('/load-library-db', async function (req, res) {
    try {
        const query = `CALL sp_load_librarydb();`;
        await db.query(query); // use async/await

        console.log('sp_load_librarydb executed successfully.');

        // Respond or redirect as needed
        res.send('Library database loaded successfully.');
    } catch (error) {
        console.error('Error executing sp_load_librarydb:', error);
        res.status(500).send('An error occurred while loading the database.');
    }
});

/*
    LISTENER
*/

app.listen(PORT, function(){            // This is the basic syntax for what is called the 'listener' which receives incoming requests on the specified PORT.
    console.log('Express started on http://localhost:' + PORT + '; press Ctrl-C to terminate.')
});