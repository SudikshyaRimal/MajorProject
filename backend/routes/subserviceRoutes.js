import express from "express";
import { createSubService, getSubServicesByCategory } from "../Controllers/subserviceController.js";

const router = express.Router();

// Create a subservice - Admin only (you can add auth later)
router.post("/create", createSubService);

// Get all subservices for a category - frontend uses this on category click
router.get("/category/:categoryId", getSubServicesByCategory);

export default router;
