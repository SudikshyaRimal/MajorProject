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

router.post('/register', userAuth,registerUser);
router.post('/login', userAuth,loginUser);
router.post('/logout', logout);
router.post('/send-reset-otp', userAuth,sendResetOtp);
router.post('/verify-reset-otp',userAuth, verifyResetOtp);
router.post('/reset-password', userAuth,resetPassword);
router.post('/edit-profile', userAuth,editProfile);
router.post('/changePassword', userAuth,changePassword);


export default router;
