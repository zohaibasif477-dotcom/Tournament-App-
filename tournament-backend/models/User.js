const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");
const bcrypt = require("bcryptjs");

const UserSchema = new mongoose.Schema({
  // 🆔 User Identity
  userID: { type: String, default: () => uuidv4(), unique: true },
  username: { type: String, required: true }, // ✅ Added / replaces 'name'
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },

  // 💰 Coins
  coins: { type: Number, default: 0 },

  // 🏆 Stats Section
  totalMatches: { type: Number, default: 0 },
  matchesWon: { type: Number, default: 0 },
  totalKills: { type: Number, default: 0 },
  coinWin: { type: Number, default: 0 },     // ✅ Added field
  totalWins: { type: Number, default: 0 },
  rank: { type: Number, default: 0 },

  // ⭐ Auto Rank / Level system
  level: { type: Number, default: 1 },
  stars: { type: Number, default: 0 },
  category: { type: String, default: "Bronze" },

  // 📢 Referral
  referralCode: { type: String, unique: true },
  referredBy: { type: String, default: null },

}, { timestamps: true }); // ✅ Added timestamps for automatic createdAt & updatedAt

// 🔐 Password hash before save
UserSchema.pre("save", async function () {
  if (!this.isModified("password")) return;

  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);
});

module.exports = mongoose.model("User", UserSchema);