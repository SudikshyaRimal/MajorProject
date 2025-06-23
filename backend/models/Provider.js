import mongoose from "mongoose";

const providerSchema = new mongoose.Schema(
  {
    firstname: { type: String, required: true },
    lastname: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    address: { type: String, required: true },

    // Removed serviceType from required registration fields
    serviceType: {
      type: String,
      required: false,
    },

    // These fields will be updated later after login
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

