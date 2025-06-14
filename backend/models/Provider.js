// models/Provider.js
import mongoose from "mongoose";

const providerSchema = new mongoose.Schema(
  {
    firstname: { type: String, required: true },
    lastname: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    address: { type: String, required: true },
    serviceType: { type: String, required: true },

    // New Fields for service assignment
    subservice: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "SubService",
      required: false,
    },
    experience: {
      type: Number,
      required: false,
    },
    price: {
      type: Number,
      required: false,
    },
    rating: {
      type: Number,
      default: 0,
    },

    // For forgot password
    resetOtp: { type: String, default: "" },
    resetOtpVerified: { type: Boolean, default: false },
    resetOtpExpireAt: { type: Date, default: 0 },
  },
  { timestamps: true }
);

export default mongoose.model("Provider", providerSchema);

