const mongoose = require("mongoose");

const JoinTournamentSchema = new mongoose.Schema({
  userID: {
    type: String,
    required: true,
  },

  tournamentID: {
    type: String,
    required: true,
  },

  joinedAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model("JoinTournament", JoinTournamentSchema);