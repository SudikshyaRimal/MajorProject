import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import Provider from "../models/Provider.js";
import transporter from "../config/nodemailer.js";

// Register Provider
export const registerProvider = async (req, res) => {
  const { firstname, lastname, email, password, address, serviceType } = req.body;

  if (!firstname || !lastname || !email || !password || !address || !serviceType) {
    return res.status(400).json({ success: false, message: "Missing required fields" });
  }

  try {
    const existingProvider = await Provider.findOne({ email });
    if (existingProvider) {
      return res.status(409).json({ success: false, message: "Provider already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const provider = new Provider({
      firstname,
      lastname,
      email,
      password: hashedPassword,
      address,
      serviceType,
    });

    await provider.save();

    const token = jwt.sign({ id: provider._id }, process.env.JWT_SECRET, {
      expiresIn: "7d",
    });

    res.cookie("token", token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: process.env.NODE_ENV === "production" ? "none" : "strict",
      maxAge: 7 * 24 * 60 * 60 * 1000,
    });

    const mailOptions = {
      from: process.env.SENDER_EMAIL,
      to: email,
      subject: "Welcome to SewaMitra",
      text: `Welcome to SewaMitra! Your provider account has been created with email: ${email}`,
    };

    await transporter.sendMail(mailOptions);

    res.status(201).json({ success: true, message: "Provider registered successfully" });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Login Provider
export const loginProvider = async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ success: false, message: "Email and password are required" });
  }

  try {
    const provider = await Provider.findOne({ email });
    if (!provider) {
      return res.status(401).json({ success: false, message: "Invalid email" });
    }

    const isMatch = await bcrypt.compare(password, provider.password);
    if (!isMatch) {
      return res.status(401).json({ success: false, message: "Invalid password" });
    }

    const token = jwt.sign({ id: provider._id }, process.env.JWT_SECRET, {
      expiresIn: "7d",
    });

    res.cookie("token", token, {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: process.env.NODE_ENV === "production" ? "none" : "strict",
      maxAge: 7 * 24 * 60 * 60 * 1000,
    });

    res.status(200).json({ success: true, message: "Login successful" });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Logout Provider
export const logoutProvider = (req, res) => {
  try {
    res.clearCookie("token", {
      httpOnly: true,
      secure: process.env.NODE_ENV === "production",
      sameSite: process.env.NODE_ENV === "production" ? "none" : "strict",
    });

    res.status(200).json({ success: true, message: "Logged out successfully" });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Send OTP to Provider
export const sendResetOtpProvider = async (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.json({ success: false, message: 'Email is required' });
  }

  try {
    const provider = await Provider.findOne({ email });
    if (!provider) {
      return res.json({ success: false, message: 'Provider not found' });
    }

    const otp = String(Math.floor(100000 + Math.random() * 900000));
    provider.resetOtp = otp;
    provider.resetOtpExpireAt = Date.now() + 15 * 60 * 1000;

    await provider.save();

    const mailOptions = {
      from: process.env.SENDER_EMAIL,
      to: provider.email,
      subject: 'Password Reset OTP',
      text: `Your OTP to reset your password is ${otp}. It is valid for 15 minutes.`,
    };

    await transporter.sendMail(mailOptions);

    return res.json({ success: true, message: 'OTP sent to your email' });
  } catch (error) {
    return res.json({ success: false, message: error.message });
  }
};

// Verify Provider OTP
export const verifyResetOtpProvider = async (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) {
    return res.json({ success: false, message: 'Email and OTP are required' });
  }

  try {
    const provider = await Provider.findOne({ email });

    if (!provider) {
      return res.json({ success: false, message: 'Provider not found' });
    }

    if (provider.resetOtp !== otp) {
      return res.json({ success: false, message: 'Invalid OTP' });
    }

    if (provider.resetOtpExpireAt < Date.now()) {
      return res.json({ success: false, message: 'OTP expired' });
    }

    provider.resetOtpVerified = true;
    await provider.save();

    return res.json({ success: true, message: 'OTP verified successfully' });
  } catch (error) {
    return res.json({ success: false, message: error.message });
  }
};

// Reset Provider Password
export const resetPasswordProvider = async (req, res) => {
  const { email, newPassword, confirmPassword } = req.body;

  if (!email || !newPassword || !confirmPassword) {
    return res.json({ success: false, message: 'All fields are required' });
  }

  if (newPassword !== confirmPassword) {
    return res.json({ success: false, message: 'Passwords do not match' });
  }

  try {
    const provider = await Provider.findOne({ email });

    if (!provider) {
      return res.json({ success: false, message: 'Provider not found' });
    }

    if (!provider.resetOtpVerified) {
      return res.json({ success: false, message: 'OTP not verified' });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    provider.password = hashedPassword;

    provider.resetOtp = '';
    provider.resetOtpVerified = false;
    provider.resetOtpExpireAt = 0;

    await provider.save();

    return res.json({ success: true, message: 'Password reset successfully' });
  } catch (error) {
    return res.json({ success: false, message: error.message });
  }
};
