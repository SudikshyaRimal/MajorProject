// controllers/bookingController.js

import Booking from "../models/BookingModel.js";
import Provider from "../models/Provider.js";
import BookingHistory from "../models/BookingHistory.js";

const createBooking = async (req, res) => {
  try {
    const userId = req.user._id;
    const {fullname, providerId, date, time, location } = req.body;

    const provider = await Provider.findById(providerId).populate("subservice");
    if (!provider || !provider.subservice) {
      return res.status(404).json({ message: "Provider or subservice not found" });
    }

    const booking = new Booking({
      user: userId,
      provider: provider._id,
      category: provider.subservice.category,
      subservice: provider.subservice._id,
      servicePrice: provider.price,
      date,
      time,
      location,
    });

    await booking.save();
    const bookingHistoryEntry = new BookingHistory({
  user: booking.user,
  provider: booking.provider,
  category: booking.category,
  subservice: booking.subservice,
  servicePrice: booking.servicePrice,
  date: booking.date,
  time: booking.time,
  location: booking.location,
  status: booking.status,
});

await bookingHistoryEntry.save();

    res.status(201).json({ message: "Booking successful", booking });
  } catch (error) {
    console.error("Booking Error:", error);
    res.status(500).json({ message: "Booking failed", error: error.message });
  }
};

const getMyBookings = async (req, res) => {
  try {
    const userId = req.user._id;

    const bookings = await Booking.find({ user: userId })
      .populate('provider', 'firstname lastname price')
      .populate('subservice', 'name')
      .populate('category', 'name');

    res.json({ success: true, bookings });
  } catch (error) {
    console.error("Fetch Booking Error:", error);
    res.status(500).json({ success: false, message: 'Server error' });
  }
};

export { createBooking, getMyBookings };


