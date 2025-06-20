import express from 'express';
import { loginAdmin, logoutAdmin } from '../Controllers/adminController.js';

const router = express.Router();

//router.post('/register', registerAdmin); // Use only once, then delete
router.post('/login', loginAdmin);
router.post('/logout', logoutAdmin);

export default router;