import jwt from "jsonwebtoken";
import Provider from "../models/Provider.js";
const providerProtect = async (req, res, next) => {
  try {
    const token = req.cookies.token;
    if (!token) return res.status(401).json({ message: "No token provided" });

    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    const provider = await Provider.findById(decoded.id).select("-password");

    if (!provider) return res.status(401).json({ message: "Invalid token" });

    req.provider = provider;
    next();
  } catch (err) {
    res.status(401).json({ message: "Auth failed" });
  }
};

export default providerProtect;

