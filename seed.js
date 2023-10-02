const mysql = require('mysql2/promise');
const Chance = require('chance');
const { format } = require('date-fns');
require('dotenv').config();

const chance = new Chance();

const date = chance.birthday();


async function seedDatabase() {
  const connection = await mysql.createConnection({
    host: process.env.DB_HOST,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME,
  });

  const students = [];
  const courses = [];
  const rooms = [];
  const teachers = [];
  const enrollments = [];
  const courseRooms = [];
  const courseTeachers = [];

  try {
    for (let i = 0; i < 10; i++) {
      // Generate unique student data
      while (true) {
        const firstName = chance.first();
        const lastName = chance.last();
        const dateOfBirth = format(chance.birthday(), 'yyyy-MM-dd');
        const currentDate = format(new Date(), 'yyyy-MM-dd');

        if (!students.some(s => s.first_name === firstName && s.last_name === lastName && s.date_of_birth === dateOfBirth)) {
          await connection.execute('INSERT INTO students (first_name, last_name, date_of_birth, enrollment_date) VALUES (?, ?, ?, ?)', [firstName, lastName, dateOfBirth, currentDate]);
          const [[{ insertId }]] = await connection.query('SELECT LAST_INSERT_ID() AS insertId');
          students.push({ student_id: insertId, first_name: firstName, last_name: lastName, date_of_birth: dateOfBirth, enrollment_date: currentDate });
          break;
        }
      }

      // Generate unique course data
      while (true) {
        const courseName = chance.word();
        const credits = chance.natural({ min: 1, max: 10 });

        if (!courses.some(c => c.course_name === courseName)) {
          await connection.execute('INSERT INTO courses (course_name, credits) VALUES (?, ?)', [courseName, credits]);
          const [[{ insertId: courseInsertId }]] = await connection.query('SELECT LAST_INSERT_ID() AS insertId');
          courses.push({ course_id: courseInsertId, course_name: courseName, credits });
          break;
        }
      }

      // Generate unique room data
      while (true) {
        const roomName = chance.word();
        const building = chance.word();
        const capacity = chance.natural({ min: 1, max: 30 });

        if (!rooms.some(r => r.room_name === roomName && r.building === building)) {
          await connection.execute('INSERT INTO rooms (room_name, building, capacity) VALUES (?, ?, ?)', [roomName, building, capacity]);
          const [[{ insertId: roomInsertId }]] = await connection.query('SELECT LAST_INSERT_ID() AS insertId');
          rooms.push({ room_id: roomInsertId, room_name: roomName, building: building, capacity });
          break;
        }
      }

      // Generate unique teacher data
      while (true) {
        const firstName = chance.first();
        const lastName = chance.last();
        const specialization = chance.word();
        const dateOfHire = format(chance.date(), 'yyyy-MM-dd');

        if (!teachers.some(t => t.first_name === firstName && t.last_name === lastName && t.specialization === specialization)) {
          await connection.execute('INSERT INTO teachers (first_name, last_name, specialization, date_of_hire) VALUES (?, ?, ?, ?)', [firstName, lastName, specialization, dateOfHire]);
          const [[{ insertId: teacherInsertId }]] = await connection.query('SELECT LAST_INSERT_ID() AS insertId');
          teachers.push({ teacher_id: teacherInsertId, first_name: firstName, last_name: lastName, specialization: specialization, date_of_hire: dateOfHire });
          break;
        }
      }
    }

    // Generate unique enrollments, course_rooms, and course_teachers data
    for (const student of students) {
      const availableCourses = courses.filter(course => !enrollments.some(enrollment => enrollment.course_id === course.course_id));
      const numberOfEnrollments = chance.natural({ min: 1, max: Math.min(5, availableCourses.length) }); // A user can only enroll in 5 classes max.
    
      for (let i = 0; i < numberOfEnrollments; i++) {
        const course = chance.pickone(availableCourses);
        await connection.execute('INSERT INTO enrollments (student_id, course_id) VALUES (?, ?)', [student.student_id, course.course_id]);
        enrollments.push({ student_id: student.student_id, course_id: course.course_id });
    
        const availableRooms = rooms.filter(room => !courseRooms.some(courseRoom => courseRoom.room_id === room.room_id));
        const room = chance.pickone(availableRooms);
        await connection.execute('INSERT INTO course_rooms (course_id, room_id) VALUES (?, ?)', [course.course_id, room.room_id]);
        courseRooms.push({ course_id: course.course_id, room_id: room.room_id });
    
        const availableTeachers = teachers.filter(teacher => !courseTeachers.some(courseTeacher => courseTeacher.teacher_id === teacher.teacher_id));
        const teacher = chance.pickone(availableTeachers);
        await connection.execute('INSERT INTO course_teachers (course_id, teacher_id) VALUES (?, ?)', [course.course_id, teacher.teacher_id]);
        courseTeachers.push({ course_id: course.course_id, teacher_id: teacher.teacher_id });
      }
    }
  } catch (err) {
    console.error('Error seeding database', err);
  } finally {
    await connection.end();
  }
}

seedDatabase();

