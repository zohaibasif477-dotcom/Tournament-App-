const express = require("express");
const router = express.Router();

const {
  createDeposit,
  getDepositHistory,
} = require("../controllers/deposit_controller");

const upload = require("../middlewares/upload");

// ⚠️ Assuming you already have auth middleware
const { protect } = require("../middlewares/authMiddleware");

// Create Deposit (with image upload)
router.post(
  "/",
  protect,
  upload.single("screenshot"),
  createDeposit
);

// Get Deposit History
router.get("/history", protect, getDepositHistory);

module.exports = router;