import { Request, Response } from 'express';
import pool from '../../database/db';

export const createRoom = async (req: Request, res: Response) => {
  const { room_name, building, capacity } = req.body;
  try {
    const [result] = await pool.execute('INSERT INTO rooms (room_name, building, capacity) VALUES (?, ?, ?)', [room_name, building, capacity]);
    res.status(201).json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const getAllRooms = async (_req: Request, res: Response) => {
  try {
    const [rooms] = await pool.query('SELECT * FROM rooms');
    res.json(rooms);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const getRoomById = async (req: Request, res: Response) => {
  const id = req.params.id;
  try {
    const [room] = await pool.query('SELECT * FROM rooms WHERE room_id = ?', [id]);
    if (Array.isArray(room) && room.length) {
      res.json(room[0]);
    } else {
      res.status(404).json({ message: 'Room not found' });
    }
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const updateRoomById = async (req: Request, res: Response) => {
  const id = req.params.id;
  const { room_name, building, capacity } = req.body;
  try {
    const [result] = await pool.execute('UPDATE rooms SET room_name = ?, building = ?, capacity = ? WHERE room_id = ?', [room_name, building, capacity, id]);
    res.json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};

export const deleteRoomById = async (req: Request, res: Response) => {
  const id = req.params.id;
  try {
    const [result] = await pool.execute('DELETE FROM rooms WHERE room_id = ?', [id]);
    res.json(result);
  } catch (error: any) {
    res.status(500).json({ message: error.message });
  }
};
