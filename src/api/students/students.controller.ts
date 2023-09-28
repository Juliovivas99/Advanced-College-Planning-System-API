// need to update app.js
import { Request, Response } from 'express';
import pool from '../../database/db';

export const createStudent = async (req: Request, res: Response) => {
    const { first_name, last_name, date_of_birth, enrollment_date } = req.body;
    try {
      const [result] = await pool.execute('INSERT INTO students (first_name, last_name, date_of_birth, enrollment_date) VALUES (?, ?, ?, ?)', [first_name, last_name, date_of_birth, enrollment_date]);
      res.status(201).json(result);
    } catch (error: any) {
      res.status(500).json({ message: error.message });
    }
  };
  
  export const getAllStudents = async (_req: Request, res: Response) => {
    try {
      const [students] = await pool.query('SELECT * FROM students');
      res.json(students);
    } catch (error: any) {
      res.status(500).json({ message: error.message });
    }
  };
  
  export const getStudentById = async (req: Request, res: Response) => {
    const id = req.params.id;
    try {
      const [student] = await pool.query('SELECT * FROM students WHERE student_id = ?', [id]);
      if (Array.isArray(student) && student.length > 0) {
        res.json(student[0]);
      } else {
        res.status(404).json({ message: 'Student not found' });
      }
    } catch (error: any) {
      res.status(500).json({ message: error.message });
    }
  };
  
  export const updateStudentById = async (req: Request, res: Response) => {
    const id = req.params.id;
    const { first_name, last_name, date_of_birth, enrollment_date } = req.body;
    try {
      const [result] = await pool.execute('UPDATE students SET first_name = ?, last_name = ?, date_of_birth = ?, enrollment_date = ? WHERE student_id = ?', [first_name, last_name, date_of_birth, enrollment_date, id]);
      res.json(result);
    } catch (error: any) {
      res.status(500).json({ message: error.message });
    }
  };
  
  export const deleteStudentById = async (req: Request, res: Response) => {
    const id = req.params.id;
    try {
      const [result] = await pool.execute('DELETE FROM students WHERE student_id = ?', [id]);
      res.json(result);
    } catch (error: any) {
      res.status(500).json({ message: error.message });
    }
  };
