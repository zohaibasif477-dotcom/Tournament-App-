const express = require("express");
const router = express.Router();
const User = require("../models/User");

// Admin updates stats for a user
router.post("/admin/update-stats/:userId", async (req, res) => {
  const { userId } = req.params;
  const { totalMatches, matchesWon, totalKills, coinWin } = req.body;

  try {
    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: "User not found" });

    user.totalMatches = totalMatches ?? user.totalMatches;
    user.matchesWon = matchesWon ?? user.matchesWon;
    user.totalKills = totalKills ?? user.totalKills;
    user.coinWin = coinWin ?? user.coinWin;

    await user.save();

    res.json({ message: "Stats updated successfully", user });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

module.exports = router;