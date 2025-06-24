import express from 'express';
import {
  registerUser,
  loginUser,
  logout,
  sendResetOtp,
  verifyResetOtp,
  resetPassword,
  editProfile,
  changePassword
} from '../Controllers/userController.js';
import userAuth from "../middleware/userAuth.js"; 

const router = express.Router();

// PUBLIC ROUTES (No Authentication Required)
router.post('/register', registerUser);           // ✅ Anyone can register
router.post('/login', loginUser);                 // ✅ Anyone can login
router.post('/logout', logout);                   // ✅ Logout doesn't need auth

// PASSWORD RESET ROUTES (Public - for users who forgot password)
router.post('/send-reset-otp', sendResetOtp);     // ✅ Anyone can request password reset
router.post('/verify-reset-otp', verifyResetOtp); // ✅ Anyone can verify OTP  
router.post('/reset-password', resetPassword);    // ✅ Anyone can reset password

// PROTECTED ROUTES (Authentication Required)
router.put('/edit-profile', userAuth, editProfile);        // 🔒 Must be logged in
router.post('/change-password', userAuth, changePassword); // 🔒 Must be logged in

// OPTIONAL: Add a profile route to get user info
router.get('/profile', userAuth, (req, res) => {
  res.status(200).json({
    success: true,
    message: "Profile retrieved successfully",
    user: req.user
  });
});

export default router;
