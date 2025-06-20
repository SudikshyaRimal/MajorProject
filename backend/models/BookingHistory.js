// models/BookingHistory.js
import mongoose from 'mongoose';

const bookingHistorySchema = new mongoose.Schema({
  user: { type: mongoose.Schema.Types.ObjectId, ref: 'User', required: true },
  provider: { type: mongoose.Schema.Types.ObjectId, ref: 'Provider', required: true },
  category: { type: 
    
    String
    //mongoose.Schema.Types.ObjectId
    , ref: 'Category', required: true },
  subservice: { type: mongoose.Schema.Types.ObjectId, ref: 'SubService', required: false },
  servicePrice: { type: Number, required: true },
  date: { type: Date, required: true },
  time: { type: String, required: true },
  location: { type: String, required: true },
  status: { 
    type: String, 
    enum: ['pending', 'confirmed', 'completed', 'cancelled'], 
    default: 'pending' 
  }
}, { timestamps: true });

export default mongoose.model('BookingHistory', bookingHistorySchema);

