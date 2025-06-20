import express from "express";
import {
  registerProvider,
  loginProvider,
  logoutProvider,
  sendResetOtpProvider,
  verifyResetOtpProvider,
  resetPasswordProvider,
   updateProviderProfile,
 getProvidersByCategory
} from "../Controllers/providerController.js";
import Provider from "../models/Provider.js"; // Import the Provider model
const router = express.Router();

// POST: Register Provider
router.post("/register", registerProvider);

// POST: Login Provider
router.post("/login", loginProvider);

// POST: Logout Provider
router.post("/logout", logoutProvider);

// POST: Send OTP for password reset
router.post("/send-otp", sendResetOtpProvider);

// POST: Verify OTP
router.post("/verify-otp", verifyResetOtpProvider);

// POST: Reset Password
router.post("/reset-password", resetPasswordProvider);
router.put("/update-profile", updateProviderProfile);
router.get("/by-category/:categoryId", getProvidersByCategory);
// Route: GET /providers?category=Painter
router.get('/getWorkers', async (req, res) => {
  const category = req.query.category;

  if (!category) {

    return res.status(400).json({ error: "Category is required in query string (e.g. ?category=Painter)" });
  }
if (category == "all") {
  const providers = await Provider.find();
    return res.json(providers);
  
}
  try {
    const providers = await Provider.find({ serviceType: category });
    res.json(providers);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch providers' });
  }
});


export default router;



