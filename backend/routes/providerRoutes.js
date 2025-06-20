import express from "express";
import {
  registerProvider,
  loginProvider,
  logoutProvider,
  sendResetOtpProvider,
  verifyResetOtpProvider,
  resetPasswordProvider,
   updateProviderProfile,
 getProvidersByCategory,
getProviderBookings, updateBookingStatus
} from "../Controllers/providerController.js";
import providerProtect from "../middleware/providerAuth.js";

const router = express.Router();

// POST: Register Provider
router.post("/register", registerProvider);

// POST: Login Provider
router.post("/login", loginProvider);

// POST: Logout Provider
router.post("/logout", logoutProvider);

// POST: Send OTP for password reset
router.post("/send-otp", sendResetOtpProvider);

// POST: Verify OTP
router.post("/verify-otp", verifyResetOtpProvider);

// POST: Reset Password
router.post("/reset-password", resetPasswordProvider);
router.put("/update-profile", updateProviderProfile);
router.get("/by-category/:categoryId", getProvidersByCategory);

router.get("/bookings", providerProtect, getProviderBookings);
router.post("/booking/status", providerProtect, updateBookingStatus);

export default router;



