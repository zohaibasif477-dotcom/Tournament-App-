const User = require("../models/User");
const Transaction = require("../models/Transaction");


// Add Coins
exports.addCoins = async (req, res) => {
  try {

    const { userID, amount } = req.body;

    const user = await User.findOne({ userID });

    if (!user) {
      return res.status(404).json({
        message: "User not found"
      });
    }

    user.coins += amount;

    await user.save();

    const transaction = new Transaction({
      userID,
      amount,
      type: "deposit",
      status: "completed"
    });

    await transaction.save();

    res.json({
      message: "Coins added successfully",
      coins: user.coins
    });

  } catch (error) {

    res.status(500).json({
      error: error.message
    });

  }
};



// Withdraw Request
exports.withdrawCoins = async (req, res) => {
  try {

    const { userID, amount } = req.body;

    const user = await User.findOne({ userID });

    if (!user) {
      return res.status(404).json({
        message: "User not found"
      });
    }

    if (user.coins < amount) {
      return res.status(400).json({
        message: "Insufficient balance"
      });
    }

    user.coins -= amount;

    await user.save();

    const transaction = new Transaction({
      userID,
      amount,
      type: "withdraw",
      status: "pending"
    });

    await transaction.save();

    res.json({
      message: "Withdraw request submitted",
      coins: user.coins
    });

  } catch (error) {

    res.status(500).json({
      error: error.message
    });

  }
};



// Transaction History
exports.getTransactions = async (req, res) => {
  try {

    const { userID } = req.params;

    const transactions = await Transaction.find({ userID });

    res.json({
      transactions
    });

  } catch (error) {

    res.status(500).json({
      error: error.message
    });

  }
};