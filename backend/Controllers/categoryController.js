import Category from "../models/Category.js";

// ✅ CREATE CATEGORY — only used once for fixed ones like Cleaner, Painter, Plumber
export const createCategory = async (req, res) => {
  try {
    const { name } = req.body;

    // Check if category already exists
    const existing = await Category.findOne({ name });
    if (existing) {
      return res.status(400).json({ message: "Category already exists" });
    }

    // Create and save new category
    const newCategory = new Category({ name });
    await newCategory.save();

    res.status(201).json({
      message: "Category created successfully",
      category: newCategory,
    });
  } catch (error) {
    console.error("Create category error:", error.message);
    res.status(500).json({ message: "Server error while creating category" });
  }
};

// ✅ GET ALL CATEGORIES — for showing buttons (Cleaner, Painter, Plumber)
export const getAllCategories = async (req, res) => {
  try {
    const categories = await Category.find().sort({ createdAt: 1 });
    res.status(200).json(categories);
  } catch (error) {
    console.error("Get categories error:", error.message);
    res.status(500).json({ message: "Server error while fetching categories" });
  }
};
