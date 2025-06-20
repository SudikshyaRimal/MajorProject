import jwt from 'jsonwebtoken';

const adminAuth = async (req, res, next) => {
  try {
    const { token } = req.cookies;

    if (!token) {
      return res.status(401).json({ success: false, message: 'Not authorized. Login again' });
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    // Attach provider ID to req object
    req.adminId = decoded.id;

    next();
  } catch (error) {
    res.status(401).json({
      success: false,
      message: 'Token verification failed: ' + error.message
    });
  }
};

export default adminAuth;
