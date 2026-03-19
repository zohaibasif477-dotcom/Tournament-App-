const mongoose = require("mongoose");

const MatchSchema = new mongoose.Schema({
  tournamentID: { type: String, required: true },

  roomID: { type: String },

  roomPassword: { type: String },

  status: {
    type: String,
    enum: ["waiting", "live", "finished"],
    default: "waiting",
  },

  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("Match", MatchSchema);