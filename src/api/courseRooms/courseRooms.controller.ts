import { Request, Response } from 'express';
import pool from '../../database/db'; 

export const assignRoomToCourse = async (req: Request, res: Response) => {
  const { course_id, room_id } = req.body;
  try {
    const [result] = await pool.execute(
      'INSERT INTO course_rooms (course_id, room_id) VALUES (?, ?)',
      [course_id, room_id]
    );
    res.status(201).json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const getRoomForCourse = async (req: Request, res: Response) => {
  const { course_id } = req.params;
  try {
    const [result] = await pool.query(
      'SELECT * FROM course_rooms WHERE course_id = ?',
      [course_id]
    );
    res.json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const removeRoomAssignmentForCourse = async (req: Request, res: Response) => {
  const { course_id } = req.params;
  try {
    const [result] = await pool.execute(
      'DELETE FROM course_rooms WHERE course_id = ?',
      [course_id]
    );
    res.json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};
