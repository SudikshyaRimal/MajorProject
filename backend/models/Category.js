import mongoose from "mongoose";

const categorySchema = new mongoose.Schema({
  name: {
    type: String,
    required: true,
    unique: true,
    enum: ["Cleaner", "Painter", "Plumber"] // Only these 3 allowed
  }
}, { timestamps: true });

const Category = mongoose.models.Category || mongoose.model("Category", categorySchema);
export default Category;
