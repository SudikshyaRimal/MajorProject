// controllers/bookingHistoryController.js
import BookingHistory from '../models/BookingHistory.js';

// Get all booking history for logged-in user
const getBookingHistory = async (req, res) => {
  try {
    const userId = req.user._id;

    const history = await BookingHistory.find({ user: userId })
      .populate('provider', 'firstname lastname')
      .populate('category', 'name')
      .populate('subservice', 'name');

    res.json({ success: true, history });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Update a booking history entry (only if belongs to user)
const updateBookingHistory = async (req, res) => {
  try {
    const userId = req.user._id;
    const { id } = req.params; // bookingHistory id
    const updateData = req.body;

    const booking = await BookingHistory.findOne({ _id: id, user: userId });
    if (!booking) return res.status(404).json({ message: 'Booking not found' });

    Object.assign(booking, updateData);
    await booking.save();

    res.json({ success: true, message: 'Booking updated', booking });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Delete a booking history entry (only if belongs to user)
const deleteBookingHistory = async (req, res) => {
  try {
    const userId = req.user._id;
    const { id } = req.params;

    const booking = await BookingHistory.findOneAndDelete({ _id: id, user: userId });
    if (!booking) return res.status(404).json({ message: 'Booking not found' });

    res.json({ success: true, message: 'Booking deleted' });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

export { getBookingHistory, updateBookingHistory, deleteBookingHistory };
