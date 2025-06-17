// middleware/authMiddleware.js
import jwt from 'jsonwebtoken';
import User from '../models/userModel.js';

const protect = async (req, res, next) => {
  try {
    const token = req.cookies.token; // ✅ Get token from cookies

    if (!token) {
      return res.status(401).json({ message: 'Not authorized, no token' });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = await User.findById(decoded.id).select('-password'); // Attach user to request
    next();
  } catch (error) {
    console.error('Auth Error:', error);
    res.status(401).json({ message: 'Not authorized, token failed' });
  }
};

export default protect;

