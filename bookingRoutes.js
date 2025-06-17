// routes/bookingRoutes.js

import express from 'express';
import { createBooking, getMyBookings } from '../controllers/bookingController.js';
import protect from '../middleware/authMiddleware.js';

const router = express.Router();

router.post('/book', protect, createBooking);
router.get('/my-bookings', protect, getMyBookings);

export default router;

