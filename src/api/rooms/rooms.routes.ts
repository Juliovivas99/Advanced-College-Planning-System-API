import express from 'express';
import { createRoom, getAllRooms, getRoomById, updateRoomById, deleteRoomById } from './rooms.controller';

const router = express.Router();

router.post('/', createRoom);
router.get('/', getAllRooms);
router.get('/:id', getRoomById);
router.put('/:id', updateRoomById);
router.delete('/:id', deleteRoomById);

export default router;
