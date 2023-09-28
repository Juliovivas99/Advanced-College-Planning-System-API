import express from 'express';
import {
  assignRoomToCourse,
  getRoomForCourse,
  removeRoomAssignmentForCourse,
} from './courseRooms.controller'; 

const router = express.Router();

router.post('/', assignRoomToCourse);
router.get('/:course_id', getRoomForCourse);
router.delete('/:course_id', removeRoomAssignmentForCourse);

export default router;
