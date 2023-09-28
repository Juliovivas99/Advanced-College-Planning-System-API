import { Request, Response } from 'express';
import pool from '../../database/db'; 

export const assignTeacherToCourse = async (req: Request, res: Response) => {
  const { course_id, teacher_id } = req.body;
  try {
    const [result] = await pool.execute(
      'INSERT INTO course_teachers (course_id, teacher_id) VALUES (?, ?)',
      [course_id, teacher_id]
    );
    res.status(201).json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const getTeachersForCourse = async (req: Request, res: Response) => {
  const { course_id } = req.params;
  try {
    const [teachers] = await pool.query(
      'SELECT * FROM teachers JOIN course_teachers ON teachers.teacher_id = course_teachers.teacher_id WHERE course_teachers.course_id = ?',
      [course_id]
    );
    res.json(teachers);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const removeTeacherAssignmentFromCourse = async (req: Request, res: Response) => {
  const { course_id, teacher_id } = req.params;
  try {
    const [result] = await pool.execute(
      'DELETE FROM course_teachers WHERE course_id = ? AND teacher_id = ?',
      [course_id, teacher_id]
    );
    res.json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};
