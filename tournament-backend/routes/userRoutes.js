const express = require("express");
const router = express.Router();
const User = require("../models/User"); // Make sure User model is imported
const { signupUser, loginUser } = require("../controllers/userController");

// 🔹 Signup & Login (fix ReferenceError)
router.post("/signup", signupUser);
router.post("/login", loginUser);

// 🔹 Get user profile with stats (new API added)
router.get("/user/:userId", async (req, res) => {
  const { userId } = req.params;

  try {
    const user = await User.findById(userId);
    if (!user) return res.status(404).json({ message: "User not found" });

    res.json({
      username: user.username || user.name,
      level: user.level,
      stars: user.stars,
      category: user.category,
      totalMatches: user.totalMatches,
      matchesWon: user.matchesWon,
      totalKills: user.totalKills,
      coinWin: user.coinWin || 0
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: "Server error" });
  }
});

module.exports = router;