import express from 'express';
import { 
    createTeacher,
    getAllTeachers,
    getTeacherById,
    updateTeacherById,
    deleteTeacherById } from './teacher.controller';

const router = express.Router();

router.post('/', createTeacher);
router.get('/', getAllTeachers);
router.get('/:id', getTeacherById);
router.put('/:id', updateTeacherById);
router.delete('/:id', deleteTeacherById);

export default router;
