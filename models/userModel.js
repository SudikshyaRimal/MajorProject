import mongoose from "mongoose";


  const userSchema = new mongoose.Schema({
  firstname: String,
  lastname: String,
  email: { type: String, required: true, unique: true },
  password: String,
  address: String,
  resetOtp: String,
  resetOtpExpireAt: Number,
  resetOtpVerified: { type: Boolean, default: false },
});

 { timestamps: true };

const User = mongoose.models.User || mongoose.model('User', userSchema);

export default User;









