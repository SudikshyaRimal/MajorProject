import express from 'express';
import {
  registerUser,
  loginUser,
  logout,
  sendResetOtp,
  verifyResetOtp,
  resetPassword
} from '../Controllers/userController.js';
import userAuth from "../middleware/userAuth.js"; 

const router = express.Router();

router.post('/register', registerUser);
router.post('/login', loginUser);
router.post('/logout', logout);
router.post('/send-reset-otp', sendResetOtp);
router.post('/verify-reset-otp', verifyResetOtp);
router.post('/reset-password', resetPassword);

export default router;
