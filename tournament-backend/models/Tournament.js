const mongoose = require("mongoose");
const { v4: uuidv4 } = require("uuid");

const TournamentSchema = new mongoose.Schema({
  tournamentID: { type: String, default: () => uuidv4(), unique: true },

  title: { type: String, required: true },

  gameName: { type: String, required: true },

  entryFee: { type: Number, required: true },

  prizePool: { type: Number, required: true },

  maxPlayers: { type: Number, required: true },

  joinedPlayers: { type: Number, default: 0 },

  status: {
    type: String,
    enum: ["upcoming", "ongoing", "completed"],
    default: "upcoming",
  },

  startTime: { type: Date, required: true },

  createdAt: { type: Date, default: Date.now },
});

module.exports = mongoose.model("Tournament", TournamentSchema);