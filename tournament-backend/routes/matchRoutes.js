const express = require("express");
const router = express.Router();

const {
  createMatch,
  getMatchByTournament
} = require("../controllers/matchController");


// Create Match
router.post("/create", createMatch);

// Get Match Details
router.get("/:tournamentID", getMatchByTournament);

module.exports = router;
