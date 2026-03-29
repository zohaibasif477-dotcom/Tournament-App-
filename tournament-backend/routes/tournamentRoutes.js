const express = require("express");
const router = express.Router();

const tournamentController = require("../controllers/tournamentController");

router.get("/tournaments", tournamentController.getAllTournaments);

router.post("/tournaments", tournamentController.createTournament);

module.exports = router;