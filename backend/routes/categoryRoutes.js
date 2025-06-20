import express from "express";
import {
  createCategory,
  getAllCategories,
} from "../Controllers/categoryController.js";

const router = express.Router();

// ✅ CREATE CATEGORY — One-time, for Admin to create fixed ones
router.post("/create", createCategory);

// ✅ GET ALL CATEGORIES — For frontend to show category buttons
router.get("/all", getAllCategories);

export default router;

