import SubService from "../models/SubService.js";
import Category from "../models/Category.js";

// Create SubService (Admin can add fixed subservices to a category)
export const createSubService = async (req, res) => {
  try {
    const { name, categoryId } = req.body;

    // Check if category exists
    const category = await Category.findById(categoryId);
    if (!category) {
      return res.status(400).json({ message: "Category not found" });
    }

    // Check if subservice with same name exists for this category
    const existing = await SubService.findOne({ name, category: categoryId });
    if (existing) {
      return res.status(400).json({ message: "SubService already exists for this category" });
    }

    const newSubService = new SubService({ name, category: categoryId });
    await newSubService.save();

    res.status(201).json({ message: "SubService created", subservice: newSubService });
  } catch (error) {
    console.error("Create subservice error:", error.message);
    res.status(500).json({ message: "Server error creating subservice" });
  }
};

// Get all subservices under a category (for frontend to display subservices when category clicked)
export const getSubServicesByCategory = async (req, res) => {
  try {
    const { categoryId } = req.params;

    // Check if category exists
    const category = await Category.findById(categoryId);
    if (!category) {
      return res.status(400).json({ message: "Category not found" });
    }

    const subservices = await SubService.find({ category: categoryId }).sort({ name: 1 });
    res.status(200).json(subservices);
  } catch (error) {
    console.error("Get subservices error:", error.message);
    res.status(500).json({ message: "Server error fetching subservices" });
  }
};
