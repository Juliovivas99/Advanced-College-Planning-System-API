const faker = require('faker');
const mysql = require('mysql2/promise');

async function populateTables() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
  });

  try {
    // Generate students
    let students = [];
    for (let i = 0; i < 10; i++) {
      const firstName = faker.name.firstName();
      const lastName = faker.name.lastName();
      const dateOfBirth = faker.date.past(20, '2000-01-01');
      const enrollmentDate = faker.date.past(4, '2018-01-01');

      // Ensure unique combination of firstName, lastName, and dateOfBirth
      if (!students.some(s => s.firstName === firstName && s.lastName === lastName && s.dateOfBirth === dateOfBirth)) {
        await connection.execute('INSERT INTO students (first_name, last_name, date_of_birth, enrollment_date) VALUES (?, ?, ?, ?)', [firstName, lastName, dateOfBirth, enrollmentDate]);
        students.push({ firstName, lastName, dateOfBirth });
      }
    }

    // Generate courses with positive credits
    for (let i = 0; i < 5; i++) {
      const courseName = faker.random.word();
      const courseDescription = faker.lorem.words(20);
      const credits = faker.random.number({ min: 1, max: 3 });
      await connection.execute('INSERT INTO courses (course_name, course_description, credits) VALUES (?, ?, ?)', [courseName, courseDescription, credits]);
    }

    // Generate rooms with capacity between 1 and 30 and unique room_name + building combinations
    let rooms = [];
    for (let i = 0; i < 5; i++) {
      const roomName = faker.random.word();
      const building = faker.address.streetName();
      const capacity = faker.random.number({ min: 1, max: 30 });

      if (!rooms.some(r => r.roomName === roomName && r.building === building)) {
        await connection.execute('INSERT INTO rooms (room_name, building, capacity) VALUES (?, ?, ?)', [roomName, building, capacity]);
        rooms.push({ roomName, building });
      }
    }

    // Generate teachers with unique first_name, last_name, and specialization combinations
    let teachers = [];
    for (let i = 0; i < 5; i++) {
      const firstName = faker.name.firstName();
      const lastName = faker.name.lastName();
      const specialization = faker.random.word();
      const dateOfHire = faker.date.past(10, '2012-01-01');

      if (!teachers.some(t => t.firstName === firstName && t.lastName === lastName && t.specialization === specialization)) {
        await connection.execute('INSERT INTO teachers (first_name, last_name, specialization, date_of_hire) VALUES (?, ?, ?, ?)', [firstName, lastName, specialization, dateOfHire]);
        teachers.push({ firstName, lastName, specialization });
      }
    }

    // Use transaction, rollback in case of error, and commit at the end.
    await connection.commit();
  } catch (error) {
    console.error(error);
    await connection.rollback();
  } finally {
    await connection.end();
  }
}

populateTables().catch(console.error);
