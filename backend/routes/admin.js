const express = require("express");
const router = express.Router();
const auth = require("../middleware/auth");
const Vehicle = require("../models/Vehicle");
const Trip = require("../models/Trip");

// Get all active vehicles with live location
router.get("/live", auth, async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ error: "Only admin can view live data" });
    }

    // find ongoing trips and populate vehicle + driver
    const trips = await Trip.find({ status: "ongoing" })
      .populate("vehicleId", "name type lastLocation")
      .populate("driverId", "username");

    res.json(trips);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
