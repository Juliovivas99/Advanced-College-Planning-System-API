import express from 'express';
import {
  assignTeacherToCourse,
  getTeachersForCourse,
  removeTeacherAssignmentFromCourse
} from './courseTeachers.controller'; 

const router = express.Router();

router.post('/', assignTeacherToCourse);
router.get('/:course_id', getTeachersForCourse);
router.delete('/:course_id/:teacher_id', removeTeacherAssignmentFromCourse);

export default router;
