import jwt from "jsonwebtoken";
import User from "../models/userModel.js"; // Import User model for complete user data

const userAuth = async (req, res, next) => {
  try {
    // Get token from Authorization header (Flutter standard)
    const authHeader = req.headers.authorization;
    
    if (!authHeader || !authHeader.startsWith('Bearer ')) {
      return res.status(401).json({ 
        success: false, 
        message: "No token provided. Please log in again." 
      });
    }

    // Extract token from "Bearer <token>"
    const token = authHeader.split(' ')[1];

    if (!token) {
      return res.status(401).json({ 
        success: false, 
        message: "Invalid token format. Please log in again." 
      });
    }

    // Verify JWT token
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    
    // Get complete user data and attach to req object
    const user = await User.findById(decoded.id).select('-password');
    
    if (!user) {
      return res.status(401).json({ 
        success: false, 
        message: "User not found. Please log in again." 
      });
    }

    // Attach user data to request object
    req.user = user;
    req.userId = decoded.id; // Keep for backward compatibility
    
    next();
  } catch (error) {
    console.error("Auth middleware error:", error);
    
    if (error.name === 'JsonWebTokenError') {
      return res.status(401).json({ 
        success: false, 
        message: "Invalid token. Please log in again." 
      });
    }
    
    if (error.name === 'TokenExpiredError') {
      return res.status(401).json({ 
        success: false, 
        message: "Token expired. Please log in again." 
      });
    }
    
    res.status(500).json({ 
      success: false, 
      message: "Authentication error. Please try again." 
    });
  }
};

export default userAuth;




