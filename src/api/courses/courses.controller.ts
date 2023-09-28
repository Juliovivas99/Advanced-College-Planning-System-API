import { Request, Response } from 'express';
import pool from '../../database/db';

export const createCourse = async (req: Request, res: Response) => {
  // Get course details from request body
  const { course_name, course_description, credits } = req.body;
  
  try {
    const [result] = await pool.execute(
      'INSERT INTO courses (course_name, course_description, credits) VALUES (?, ?, ?)',
      [course_name, course_description, credits]
    );
    
    res.status(201).json(result);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getAllCourses = async (_req: Request, res: Response) => {
  try {
    const [courses] = await pool.query('SELECT * FROM courses');
    res.json(courses);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const getCourseById = async (req: Request, res: Response) => {
  const { id } = req.params;
  
  try {
    const [course] = await pool.query('SELECT * FROM courses WHERE course_id = ?', [id]);
    
    if (course.length) {
      res.json(course[0]);
    } else {
      res.status(404).json({ message: 'Course not found' });
    }
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const updateCourseById = async (req: Request, res: Response) => {
  const { id } = req.params;
  const { course_name, course_description, credits } = req.body;
  
  try {
    const [result] = await pool.execute(
      'UPDATE courses SET course_name = ?, course_description = ?, credits = ? WHERE course_id = ?',
      [course_name, course_description, credits, id]
    );
    
    res.json(result);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteCourseById = async (req: Request, res: Response) => {
  const { id } = req.params;
  
  try {
    const [result] = await pool.execute('DELETE FROM courses WHERE course_id = ?', [id]);
    res.json(result);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
};
