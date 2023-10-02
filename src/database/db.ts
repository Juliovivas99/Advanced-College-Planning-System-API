import mysql from 'mysql2/promise';
require('dotenv').config();

// Create a connection pool
const pool = mysql.createPool({
  host: process.env.DB_HOST,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  database: process.env.DB_NAME,
  waitForConnections: true,
  connectionLimit: 10,
});

pool.query('SELECT 1')
  .then(() => console.log('Connected to the MySQL database.'))
  .catch((err) => console.error('Error connecting to the MySQL database.', err));


export default pool;
