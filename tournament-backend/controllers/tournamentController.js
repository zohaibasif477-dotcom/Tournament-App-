const Tournament = require("../models/Tournament");
const JoinTournament = require("../models/JoinTournament");

// ------------------------------
// Create Tournament
// ------------------------------
exports.createTournament = async (req, res) => {
  console.log("➡️ Create Tournament API called", req.body);

  try {
    const { title, gameName, entryFee, prizePool, maxPlayers, startTime } = req.body;

    // Validate required fields
    if (!title || !gameName || !entryFee || !prizePool || !maxPlayers || !startTime) {
      console.warn("⚠️ Missing required field in request body");
      return res.status(400).json({
        message: "Missing required fields",
      });
    }

    // Validate startTime format
    const startDate = new Date(startTime);
    if (isNaN(startDate.getTime())) {
      console.warn("⚠️ Invalid startTime format:", startTime);
      return res.status(400).json({
        message: "Invalid startTime format. Use YYYY-MM-DDTHH:MM:SSZ",
      });
    }

    const newTournament = new Tournament({
      title,
      gameName,
      entryFee,
      prizePool,
      maxPlayers,
      startTime: startDate,
      joinedPlayers: 0,
    });

    await newTournament.save();
    console.log("✅ Tournament created:", newTournament._id);

    res.status(201).json({
      message: "Tournament created successfully",
      tournament: newTournament,
    });
  } catch (error) {
    console.error("❌ Create Tournament Error:", error);
    res.status(500).json({
      message: "Server Error",
      error: error.message,
    });
  }
};

// ------------------------------
// Get All Tournaments
// ------------------------------
exports.getAllTournaments = async (req, res) => {
  console.log("➡️ Get All Tournaments API called");

  try {
    const tournaments = await Tournament.find().sort({ createdAt: -1 });
    console.log(`✅ ${tournaments.length} tournaments fetched`);
    res.status(200).json({
      success: true,
      data: tournaments
    });
  } catch (error) {
    console.error("❌ Get All Tournaments Error:", error);
    res.status(500).json({
      message: "Server Error",
      error: error.message,
    });
  }
};

// ------------------------------
// Join Tournament
// ------------------------------
exports.joinTournament = async (req, res) => {
  console.log("➡️ Join Tournament API called", req.body);

  try {
    const { userID, tournamentID } = req.body;

    if (!userID || !tournamentID) {
      console.warn("⚠️ Missing userID or tournamentID");
      return res.status(400).json({ message: "Missing userID or tournamentID" });
    }

    const tournament = await Tournament.findById(tournamentID);
    if (!tournament) {
      console.warn("⚠️ Tournament not found:", tournamentID);
      return res.status(404).json({ message: "Tournament not found" });
    }

    if ((tournament.joinedPlayers || 0) >= tournament.maxPlayers) {
      console.warn("⚠️ Tournament full:", tournamentID);
      return res.status(400).json({ message: "Tournament is full" });
    }

    const alreadyJoined = await JoinTournament.findOne({ userID, tournamentID });
    if (alreadyJoined) {
      console.warn("⚠️ User already joined tournament:", userID, tournamentID);
      return res.status(400).json({ message: "User already joined this tournament" });
    }

    const join = new JoinTournament({ userID, tournamentID });
    await join.save();

    tournament.joinedPlayers = (tournament.joinedPlayers || 0) + 1;
    await tournament.save();

    console.log("✅ User joined tournament:", userID, tournamentID);
    res.status(200).json({ message: "Tournament joined successfully" });

  } catch (error) {
    console.error("❌ Join Tournament Error:", error);
    res.status(500).json({ message: "Server Error", error: error.message });
  }
};