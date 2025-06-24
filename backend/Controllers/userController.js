import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import User from "../models/userModel.js";
import transporter from "../config/nodemailer.js";

// User Registration
export const registerUser = async (req, res) => {
  const { firstname, lastname, email, password, address } = req.body;

  if (!firstname || !lastname || !email || !password || !address) {
    return res.status(400).json({ success: false, message: "Missing required fields" });
  }

  try {
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(409).json({ success: false, message: "User already exists" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const user = new User({
      firstname,
      lastname,
      email,
      password: hashedPassword,
      address,
    });

    await user.save();

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
      expiresIn: "7d",
    });

    // Send welcome email
    const mailOptions = {
      from: process.env.SENDER_EMAIL,
      to: email,
      subject: "Welcome to Sewamitra",
      text: `Welcome to Sewamitra! Your account has been created with the email: ${email}`,
    };

    await transporter.sendMail(mailOptions);
   
    // FIXED: Return token in response body for Flutter
    res.status(201).json({
      success: true,
      message: "User registered successfully",
      token: token, // Flutter can store this
      user: {
        id: user._id,
        firstname: user.firstname,
        lastname: user.lastname,
        email: user.email,
        address: user.address
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// User Login
export const loginUser = async (req, res) => {
  const { email, password } = req.body;

  if (!email || !password) {
    return res.status(400).json({ success: false, message: "Email and password are required" });
  }

  try {
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ success: false, message: "Invalid email" });
    }

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ success: false, message: "Invalid password" });
    }

    const token = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
      expiresIn: "7d",
    });

    // FIXED: Return token in response body for Flutter
    res.status(200).json({ 
      success: true, 
      message: "Login successful",
      token: token, // Flutter can store this
      user: {
        id: user._id,
        firstname: user.firstname,
        lastname: user.lastname,
        email: user.email,
        address: user.address
      }
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// User Logout
export const logout = (req, res) => {
  try {
    // For Flutter, logout is handled client-side by removing the token
    // No server-side action needed since we're not using cookies
    res.status(200).json({ 
      success: true, 
      message: "Logged out successfully. Please remove token from client storage." 
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

// Reset OTP
export const sendResetOtp = async (req, res) => {
  const { email } = req.body;

  if (!email) {
    return res.json({ success: false, message: 'Email is required' });
  }

  try {
    const user = await User.findOne({ email });
    if (!user) {
      return res.json({ success: false, message: 'User not found' });
    }

    const otp = String(Math.floor(100000 + Math.random() * 900000));
    user.resetOtp = otp;
    user.resetOtpExpireAt = Date.now() + 15 * 60 * 1000; // 15 mins

    await user.save();

    const mailOptions = {
      from: process.env.SENDER_EMAIL,
      to: user.email,
      subject: 'Password Reset OTP',
      text: `Your OTP to reset your password is ${otp}. It is valid for 15 minutes.`,
    };

    await transporter.sendMail(mailOptions);

    return res.json({ success: true, message: 'OTP sent to your email' });
  } catch (error) {
    return res.json({ success: false, message: error.message });
  }
};

export const verifyResetOtp = async (req, res) => {
  const { email, otp } = req.body;

  if (!email || !otp) {
    return res.json({ success: false, message: 'Email and OTP are required' });
  }

  try {
    const user = await User.findOne({ email });

    if (!user) {
      return res.json({ success: false, message: 'User not found' });
    }

    if (user.resetOtp !== otp) {
      return res.json({ success: false, message: 'Invalid OTP' });
    }

    if (user.resetOtpExpireAt < Date.now()) {
      return res.json({ success: false, message: 'OTP expired' });
    }

    // Mark OTP as verified
    user.resetOtpVerified = true;
    await user.save();

    return res.json({ success: true, message: 'OTP verified successfully' });
  } catch (error) {
    return res.json({ success: false, message: error.message });
  }
};

export const resetPassword = async (req, res) => {
  const { email, newPassword, confirmPassword } = req.body;

  if (!email || !newPassword || !confirmPassword) {
    return res.json({ success: false, message: 'All fields are required' });
  }

  if (newPassword !== confirmPassword) {
    return res.json({ success: false, message: 'Passwords do not match' });
  }

  try {
    const user = await User.findOne({ email });

    if (!user) {
      return res.json({ success: false, message: 'User not found' });
    }

    if (!user.resetOtpVerified) {
      return res.json({ success: false, message: 'OTP not verified' });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    user.password = hashedPassword;

    // Clear reset OTP data
    user.resetOtp = '';
    user.resetOtpVerified = false;
    user.resetOtpExpireAt = 0;

    await user.save();

    return res.json({ success: true, message: 'Password reset successfully' });
  } catch (error) {
    return res.json({ success: false, message: error.message });
  }
};

// Update profile
export const editProfile = async (req, res) => {
  try {
    if (!req.user || !req.user._id) {
      return res.status(401).json({ success: false, message: "Unauthorized: User not authenticated" });
    }

    const { firstname, lastname, email, address } = req.body;
    const userId = req.user._id;

    const existingUser = await User.findById(userId);
    if (!existingUser) {
      return res.status(404).json({ success: false, message: "User not found" });
    }

    const updatedUser = await User.findByIdAndUpdate(
      userId,
      { firstname, lastname, email, address },
      { new: true }
    );

    res.status(200).json({
      success: true,
      message: "Profile updated successfully",
      user: updatedUser,
    });
  } catch (error) {
    console.error("Update profile error:", error);
    res.status(500).json({ success: false, message: error.message });
  }
};

// Change password
export const changePassword = async (req, res) => {
  try {
    if (!req.user || !req.user._id) {
      return res.status(401).json({ success: false, message: "Unauthorized: User not authenticated" });
    }

    const { oldPassword, newPassword, confirmPassword } = req.body;

    if (newPassword !== confirmPassword) {
      return res.status(400).json({ success: false, message: "New passwords do not match" });
    }

    const userId = req.user._id;
    const user = await User.findById(userId);

    if (!user) {
      return res.status(404).json({ success: false, message: "User not found" });
    }

    const isMatch = await bcrypt.compare(oldPassword, user.password);
    if (!isMatch) {
      return res.status(400).json({ success: false, message: "Old password is incorrect" });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    user.password = hashedPassword;
    await user.save();

    res.status(200).json({ success: true, message: "Password changed successfully" });
  } catch (error) {
    console.error("Change password error:", error);
    res.status(500).json({ success: false, message: "Internal Server Error" });
  }
};
