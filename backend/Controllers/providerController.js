import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import Provider from "../models/Provider.js";
import SubService from "../models/SubService.js";
import transporter from "../config/nodemailer.js";
import Booking from "../models/BookingModel.js";

// Register Provider
export const registerProvider = async (req, res) => {
  const { firstname, lastname, email, password, address } = req.body;

  if (!firstname || !lastname || !email || !password || !address) {
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

    res.status(201).json({
      success: true,
      message: "Provider registered successfully",
      provider: {
        id: provider._id,
        firstname: provider.firstname,
        lastname: provider.lastname,
        email: provider.email,
      }
    });
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
export const updateProviderProfile = async (req, res) => {
  try {
    const { providerId,serviceType, subserviceId, experience, price } = req.body;

    // Check required fields
    if (!providerId ||!serviceType|| !subserviceId || !experience || !price) {
      return res.status(400).json({ message: "All fields are required" });
    }

    // Validate subservice exists
    const subservice = await SubService.findById(subserviceId);
    if (!subservice) {
      return res.status(400).json({ message: "Subservice not found" });
    }

    const provider = await Provider.findById(providerId);
    if (!provider) {
      return res.status(404).json({ message: "Provider not found" });
    }

    // Update service fields
    provider.serviceType = serviceType; // Assuming serviceType is passed in the request body
    provider.subservice = subserviceId;
    provider.experience = experience;
    provider.price = price;

    await provider.save();

    res.status(200).json({ message: "Profile updated successfully", provider });
  } catch (error) {
    console.error("Update Provider Error:", error.message);
    res.status(500).json({ message: "Server error updating provider" });
  }
};

export const getProvidersByCategory = async (req, res) => {
  const { categoryId } = req.params;

  try {
    // 1. Get all subservices for this category
    const subservices = await SubService.find({ category: categoryId });

    // 2. Get providers whose subservice is in these subservices
    const providers = await Provider.find({
      subservice: { $in: subservices.map((s) => s._id) },
    })
      .populate({
        path: "subservice",
        select: "name", // 👈 only include subservice name
      })
      .select("firstname lastname email subservice experience price"); // 👈 only these fields

    res.status(200).json({ providers });
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: "Failed to get providers" });
  }
};

export const getProviderBookings = async (req, res) => {
  try {
    const providerId = req.provider._id; // must come from provider auth middleware

    const bookings = await Booking.find({ provider: providerId })
      .populate("user", "firstname lastname email")
      .populate("category", "name")
      .populate("subservice", "name");

    res.json({ success: true, bookings });
  } catch (error) {
    console.error("Error fetching provider bookings:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
};

export const updateBookingStatus = async (req, res) => {
  try {
    const providerId = req.provider._id;
    const { bookingId, action } = req.body;

    if (!["confirmed", "cancelled"].includes(action)) {
      return res.status(400).json({ message: "Invalid action" });
    }

    const booking = await Booking.findOne({ _id: bookingId, provider: providerId });
    if (!booking) {
      return res.status(404).json({ message: "Booking not found" });
    }

    booking.status = action;
    await booking.save();

    res.json({ success: true, message: `Booking ${action}`, booking });
  } catch (error) {
    console.error("Status update error:", error);
    res.status(500).json({ success: false, message: "Server error" });
  }
};


