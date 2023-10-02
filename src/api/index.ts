import express from 'express';
import studentRoutes from './students/students.routes';
import courseRoutes from './courses/courses.routes';
import roomRoutes from './rooms/rooms.routes';
import teacherRoutes from './teachers/teacher.routes';
import courseRoomsRoutes from './courseRooms/courseRooms.routes'; 
import courseTeachersRoutes from './courseTeachers/courseTeachers.routes';


import MessageResponse from '../interfaces/MessageResponse';
import emojis from './emojis';

const router = express.Router();

router.get<{}, MessageResponse>('/', (req, res) => {
  res.json({
    message: 'API - 👋🌎🌍🌏',
  });
});

router.use('/emojis', emojis);
router.use('/students', studentRoutes);
router.use('/courses', courseRoutes);
router.use('/rooms', roomRoutes);
router.use('/teachers', teacherRoutes);
router.use('/course-rooms', courseRoomsRoutes);
router.use('/course-teachers', courseTeachersRoutes);




export default router;
