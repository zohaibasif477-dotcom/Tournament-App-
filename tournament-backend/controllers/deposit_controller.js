const Deposit = require("../models/deposit_model");

// @desc    Create Deposit Request
// @route   POST /api/deposit
// @access  Private
const createDeposit = async (req, res) => {
  try {
    const { amount } = req.body;

    if (!amount) {
      return res.status(400).json({
        success: false,
        message: "Amount is required",
      });
    }

    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: "Screenshot is required",
      });
    }

    const deposit = await Deposit.create({
      user: req.user._id,
      amount: Number(amount),
      screenshot: req.file.path,
      status: "pending",
    });

    return res.status(201).json({
      success: true,
      message: "Deposit request submitted",
      data: deposit,
    });
  } catch (error) {
    console.error("Create Deposit Error:", error);
    res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};

// @desc    Get User Deposit History
// @route   GET /api/deposit/history
// @access  Private
const getDepositHistory = async (req, res) => {
  try {
    const deposits = await Deposit.find({ user: req.user._id })
      .sort({ createdAt: -1 });

    return res.status(200).json({
      success: true,
      data: deposits,
    });
  } catch (error) {
    console.error("Get Deposit History Error:", error);
    res.status(500).json({
      success: false,
      message: "Server Error",
    });
  }
};

module.exports = {
  createDeposit,
  getDepositHistory,
};