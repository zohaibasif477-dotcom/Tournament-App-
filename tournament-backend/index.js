const express = require("express");
const connectDB = require("./db");
const mongoose = require("mongoose");
const cors = require("cors");

// Routes
const userRoutes = require("./routes/userRoutes");
const tournamentRoutes = require("./routes/tournamentRoutes");
const matchRoutes = require("./routes/matchRoutes");
const walletRoutes = require("./routes/walletRoutes");
const apiRoutes = require("./routes/api");

const app = express();

// Connect Database
connectDB()
  .then(() => console.log("✅ Database connection successful"))
  .catch((err) => console.error("❌ Database connection error:", err));

// ================= CORS & Preflight Fix =================

// ✅ FULL CORS Setup
app.use(cors({
  origin: "*", // allow all origins
  methods: ["GET", "POST", "PUT", "DELETE", "OPTIONS"],
  allowedHeaders: ["Content-Type", "Authorization"],
  credentials: true, // optional
}));

// ✅ Safe preflight handler (Express 4.x compatible)
// This replaces app.options("*", cors(...)) which causes PathError
app.use((req, res, next) => {
  if (req.method === "OPTIONS") {
    res.header("Access-Control-Allow-Origin", "*");
    res.header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS");
    res.header("Access-Control-Allow-Headers", "Content-Type, Authorization");
    return res.sendStatus(204); // Preflight OK
  }
  next();
});

// Body parser
app.use(express.json());

// Logging Middleware
app.use((req, res, next) => {
  console.log(`➡️ [${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// Routes
app.use("/api/users", userRoutes);
app.use("/api", tournamentRoutes);
app.use("/api/match", matchRoutes);
app.use("/api/wallet", walletRoutes);
app.use("/api", apiRoutes);
app.use("/api/admin", require("./routes/adminRoutes"));
app.use("/api/users", require("./routes/userRoutes"));

// 404 Handler
app.use((req, res) => {
  console.warn(`⚠️ 404 Not Found: ${req.method} ${req.url}`);
  res.status(404).json({ message: "Route not found" });
});

// Global Error Handler
app.use((err, req, res, next) => {
  console.error(`❌ Uncaught error: ${err.stack}`);
  res.status(500).json({
    message: "Internal Server Error",
    error: err.message,
  });
});

// Server
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`🌐 Environment: ${process.env.NODE_ENV || "development"}`);
});

// Handle errors
process.on("unhandledRejection", (reason, promise) => {
  console.error("❌ Unhandled Rejection:", reason);
});

process.on("uncaughtException", (err) => {
  console.error("❌ Uncaught Exception:", err);
  process.exit(1);
});