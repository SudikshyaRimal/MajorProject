import express from 'express';
import protect from '../middleware/authMiddleware.js';
import { getBookingHistory, updateBookingHistory, deleteBookingHistory } from '../Controllers/bookinghistoryController.js';

const router = express.Router();

router.get('/get', protect, getBookingHistory); // GET all history of logged user
router.put('/:id', protect, updateBookingHistory); // Update booking history by id
router.delete('/:id', protect, deleteBookingHistory); // Delete booking history by id

export default router;