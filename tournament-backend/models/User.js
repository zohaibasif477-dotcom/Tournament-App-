const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");
const bcrypt = require("bcryptjs");

const UserSchema = new mongoose.Schema({
  userID: { type: String, default: () => uuidv4(), unique: true },
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  coins: { type: Number, default: 0 },
  totalWins: { type: Number, default: 0 },
  totalKills: { type: Number, default: 0 },
  rank: { type: Number, default: 0 },
  referralCode: { type: String, unique: true },
  referredBy: { type: String, default: null },
  createdAt: { type: Date, default: Date.now }
});

UserSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();

  const salt = await bcrypt.genSalt(10);
  this.password = await bcrypt.hash(this.password, salt);

  next();
});

module.exports = mongoose.model("User", UserSchema);