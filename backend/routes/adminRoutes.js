import express from 'express';
import { loginAdmin, logoutAdmin, registerAdmin } from '../Controllers/adminController.js';

const router = express.Router();

router.post('/register', registerAdmin); // You can disable or delete after one-time use
router.post('/login', loginAdmin);
router.post('/logout', logoutAdmin);

export default router;
