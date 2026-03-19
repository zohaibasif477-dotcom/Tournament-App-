const User = require("../models/User");
const bcrypt = require("bcryptjs");

exports.signupUser = async (req, res) => {
  try {
    const { name, email, password } = req.body;

    // 1️⃣ Check if user already exists
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ success: false, message: "User already exists" });
    }

    // 2️⃣ Hash password
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    // 3️⃣ Save user with hashed password
    const user = new User({ name, email, password: hashedPassword });
    await user.save();

    // 4️⃣ Return response in expected format
    res.status(201).json({ success: true, data: { userID: user._id, name: user.name, email: user.email } });

  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });

    if (!user) {
      return res.status(400).json({ success: false, message: "User not found" });
    }

    const isMatch = await bcrypt.compare(password, user.password);

    if (!isMatch) {
      return res.status(400).json({ success: false, message: "Invalid password" });
    }

    res.json({
      success: true,
      message: "Login successful",
      data: { userID: user._id, name: user.name, email: user.email }
    });

  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};