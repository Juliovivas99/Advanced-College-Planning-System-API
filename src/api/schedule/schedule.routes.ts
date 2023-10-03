import express from 'express';
import { 
    addSchedule, 
    getSchedulesForCourse, 
    updateSchedule, 
    deleteSchedule,
    getAllSchedules 
} from './schedule.controller';

const router = express.Router();

router.post('/', addSchedule);
router.get('/', getAllSchedules)
router.get('/:course_id', getSchedulesForCourse);
router.put('/:schedule_id', updateSchedule);
router.delete('/:schedule_id', deleteSchedule);

export default router;
