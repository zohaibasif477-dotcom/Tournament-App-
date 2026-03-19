const express = require("express");
const connectDB = require("./db");
const cors = require("cors");

// Routes
const userRoutes = require("./routes/userRoutes");
const tournamentRoutes = require("./routes/tournamentRoutes");
const matchRoutes = require("./routes/matchRoutes");
const walletRoutes = require("./routes/walletRoutes");

const app = express();

// Connect Database
connectDB()
  .then(() => console.log("✅ Database connection successful"))
  .catch((err) => console.error("❌ Database connection error:", err));

// Middleware
app.use(cors()); // Enable CORS for all routes
app.use(express.json());

// Logging Middleware: Every request
app.use((req, res, next) => {
  console.log(`➡️ [${new Date().toISOString()}] ${req.method} ${req.url}`);
  next();
});

// Routes
app.use("/api/users", userRoutes);
app.use("/api/tournaments", tournamentRoutes);
app.use("/api/match", matchRoutes);
app.use("/api/wallet", walletRoutes);

// 404 Handler
app.use((req, res, next) => {
  console.warn(`⚠️ 404 Not Found: ${req.method} ${req.url}`);
  res.status(404).json({ message: "Route not found" });
});

// Global Error Handler
app.use((err, req, res, next) => {
  console.error(`❌ Uncaught error: ${err.stack}`);
  res.status(500).json({ message: "Internal Server Error", error: err.message });
});

// Server
const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`🚀 Server running on port ${PORT}`);
  console.log(`🌐 Environment: ${process.env.NODE_ENV || "development"}`);
});

// Handle unhandled rejections
process.on("unhandledRejection", (reason, promise) => {
  console.error("❌ Unhandled Rejection at:", promise, "reason:", reason);
});

// Handle uncaught exceptions
process.on("uncaughtException", (err) => {
  console.error("❌ Uncaught Exception thrown:", err);
  process.exit(1); // Exit process for serious errors
});