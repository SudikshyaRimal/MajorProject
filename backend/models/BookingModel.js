
import mongoose from 'mongoose';

const bookingSchema = new mongoose.Schema(
  {
      
   
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true
    },
    provider: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Provider',
      required: true
    },
    category: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Category', // renamed from "service" to correct model
      required: true
    },
    subservice: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'SubService',
      required: true
    },
    servicePrice: {
      type: Number,
      required: true // Will be copied from provider.price at booking time
    },
    date: {
      type: Date,
      required: true
    },
    time: {
      type: String,
      required: true
    },
    location: {
      type: String,
      required: true
    },
    status: {
      type: String,
      enum: ['pending', 'confirmed', 'completed', 'cancelled'],
      default: 'pending'
    }
  },
  { timestamps: true } // handles createdAt and updatedAt automatically
);

export default mongoose.model('Booking', bookingSchema);
