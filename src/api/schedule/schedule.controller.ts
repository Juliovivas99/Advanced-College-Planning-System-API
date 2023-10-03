import { Request, Response } from 'express';
import pool from '../../database/db'; 


export const getAllSchedules = async (req: Request, res: Response) => {
    try {
      const [schedules] = await pool.query('SELECT * FROM schedule');
      res.json(schedules);
    } catch (error: any) {
      res.status(500).json({ message: error.message });
    }
  };

export const addSchedule = async (req: Request, res: Response) => {
  const { course_id, day_of_week, start_time, end_time } = req.body;
  try {
    const [result] = await pool.execute(
      'INSERT INTO schedule (course_id, day_of_week, start_time, end_time) VALUES (?, ?, ?, ?)',
      [course_id, day_of_week, start_time, end_time]
    );
    res.status(201).json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const getSchedulesForCourse = async (req: Request, res: Response) => {
  const { course_id } = req.params;
  try {
    const [schedules] = await pool.query(
      'SELECT * FROM schedule WHERE course_id = ?',
      [course_id]
    );
    res.json(schedules);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const updateSchedule = async (req: Request, res: Response) => {
  const { schedule_id } = req.params;
  const { course_id, day_of_week, start_time, end_time } = req.body;
  try {
    const [result] = await pool.execute(
      'UPDATE schedule SET course_id = ?, day_of_week = ?, start_time = ?, end_time = ? WHERE schedule_id = ?',
      [course_id, day_of_week, start_time, end_time, schedule_id]
    );
    res.json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteSchedule = async (req: Request, res: Response) => {
  const { schedule_id } = req.params;
  try {
    const [result] = await pool.execute(
      'DELETE FROM schedule WHERE schedule_id = ?',
      [schedule_id]
    );
    res.json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};
