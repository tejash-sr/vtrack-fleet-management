const express = require("express");
const router = express.Router();
const Vehicle = require("../models/Vehicle");
const Trip = require("../models/Trip");
const auth = require("../middleware/auth");

// 📌 Get live location of all vehicles (admin only)
router.get("/live-vehicles", auth, async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ error: "Only admin can view live vehicles" });
    }

    const vehicles = await Vehicle.find()
      .populate("driverId", "username role")
      .select("name type status lastLocation driverId");

    res.json(vehicles);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📌 Get trip history of a vehicle for a given day
router.get("/trip-history/:vehicleId/:day", auth, async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ error: "Only admin can view trip history" });
    }

    const { vehicleId, day } = req.params;

    const trip = await Trip.findOne({ vehicleId, day })
      .populate("vehicleId", "name type")
      .populate("driverId", "username");

    if (!trip) return res.status(404).json({ error: "No trip found" });

    res.json(trip);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📌 Fleet summary (quick counts)
router.get("/summary", auth, async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ error: "Only admin can view summary" });
    }

    const totalVehicles = await Vehicle.countDocuments();
    const activeVehicles = await Vehicle.countDocuments({ status: "active" });
    const inactiveVehicles = await Vehicle.countDocuments({ status: "inactive" });

    const ongoingTrips = await Trip.countDocuments({ status: "ongoing" });
    const completedTrips = await Trip.countDocuments({ status: "completed" });

    res.json({
      totalVehicles,
      activeVehicles,
      inactiveVehicles,
      ongoingTrips,
      completedTrips,
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
