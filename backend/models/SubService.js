import mongoose from "mongoose";

const subServiceSchema = new mongoose.Schema(
  {
    name: {
      type: String,
      required: true,
    },
    category: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Category",
      required: true,
    },
  },
  { timestamps: true }
);

const SubService =
  mongoose.models.SubService || mongoose.model("SubService", subServiceSchema);
export default SubService;
