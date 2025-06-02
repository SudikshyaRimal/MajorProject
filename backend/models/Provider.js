import mongoose from "mongoose";

const providerSchema = new mongoose.Schema({
  firstname: {
    type: String,
    required: true,
  },
  lastname: {
    type: String,
    required: true,
  },
  email: {
    type: String,
    required: true,
    unique: true,
  },
  password: {
    type: String,
    required: true,
  },
  address: {
    type: String,
    required: true,
  },
  serviceType: {
    type: String,
    required: true,
  },
  resetOtp: {
    type: String,
    default: "",
  },
  resetOtpVerified: {
    type: Boolean,
    default: false,
  },
  resetOtpExpireAt: {
    type: Date,
    default: 0,
  },
}, { timestamps: true });

const Provider = mongoose.model("Provider", providerSchema);

export default Provider;

