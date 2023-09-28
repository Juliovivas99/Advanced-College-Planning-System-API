import { Request, Response } from 'express';
import pool from '../../database/db';

export const createTeacher = async (req: Request, res: Response) => {
  const { first_name, last_name, specialization, date_of_hire } = req.body;
  try {
    const [result] = await pool.execute('INSERT INTO teachers (first_name, last_name, specialization, date_of_hire) VALUES (?, ?, ?, ?)', [first_name, last_name, specialization, date_of_hire]);
    res.status(201).json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const getAllTeachers = async (_req: Request, res: Response) => {
  try {
    const [teachers] = await pool.query('SELECT * FROM teachers');
    res.json(teachers);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const getTeacherById = async (req: Request, res: Response) => {
  const id = req.params.id;
  try {
    const [teacher] = await pool.query('SELECT * FROM teachers WHERE teacher_id = ?', [id]); 
    if (Array.isArray(teacher) && teacher.length > 0) {
      res.json(teacher[0]);
    } else {
      res.status(404).json({ message: 'Teacher not found' });
    }
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};


export const updateTeacherById = async (req: Request, res: Response) => {
  const id = req.params.id;
  const { first_name, last_name, specialization, date_of_hire } = req.body;
  try {
    const [result] = await pool.execute('UPDATE teachers SET first_name = ?, last_name = ?, specialization = ?, date_of_hire = ? WHERE teacher_id = ?', [first_name, last_name, specialization, date_of_hire, id]);
    res.json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteTeacherById = async (req: Request, res: Response) => {
  const id = req.params.id;
  try {
    const [result] = await pool.execute('DELETE FROM teachers WHERE teacher_id = ?', [id]);
    res.json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};
