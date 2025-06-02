import express from "express";
import cors from "cors";
import cookieParser from "cookie-parser";
import 'dotenv/config';

import connectDB from "./config/connectionDB.js";
import userRoutes from "./routes/userRoutes.js";
import adminRoutes from './routes/adminRoutes.js';
import providerRoutes from './routes/providerRoutes.js';

const app = express();
const port = process.env.PORT || 4000;

// Connect to DB
connectDB();

// Middlewares 
app.use(express.json());
app.use(cookieParser());
app.use(cors({ credentials: true }));

// Routes
app.use("/api/user", userRoutes); // example: /api/user/register
app.use("/api/provider", providerRoutes);
app.use('/api/admin', adminRoutes);



app.get("/", (req, res) => {
  res.send("API working");
});

app.listen(port, () => {
  console.log(`Server started on PORT: ${port}`);
});
