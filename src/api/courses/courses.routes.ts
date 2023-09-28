import express from 'express';
import { 
    getAllCourses, 
    getCourseById, 
    createCourse, 
    updateCourseById, 
    deleteCourseById } from './courses.controller';

const router = express.Router();

router.post('/', createCourse);
router.get('/', getAllCourses);
router.get('/:id', getCourseById);
router.put('/:id', updateCourseById);
router.delete('/:id', deleteCourseById);

export default router;
