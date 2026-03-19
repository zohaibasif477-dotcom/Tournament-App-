const express = require("express");
const router = express.Router();

const {
  createTournament,
  getAllTournaments,
  joinTournament
} = require("../controllers/tournamentController");


// Create Tournament
router.post("/create", createTournament);

// Get All Tournaments
router.get("/all", getAllTournaments);

// Join Tournament
router.post("/join", joinTournament);

module.exports = router;