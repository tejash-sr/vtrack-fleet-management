const express = require("express");
const router = express.Router();
const Trip = require("../models/Trip");
const Vehicle = require("../models/Vehicle");
const auth = require("../middleware/auth");

// 🌍 Haversine formula to calculate distance between 2 lat/lng points
function haversineDistance(coord1, coord2) {
  const toRad = (x) => (x * Math.PI) / 180;
  const R = 6371e3; // meters
  const lat1 = toRad(coord1.lat);
  const lat2 = toRad(coord2.lat);
  const dLat = toRad(coord2.lat - coord1.lat);
  const dLng = toRad(coord2.lng - coord1.lng);

  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(lat1) *
      Math.cos(lat2) *
      Math.sin(dLng / 2) *
      Math.sin(dLng / 2);

  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c; // meters
}

// 📌 Helper: convert meters to kilometers (rounded to 2 decimals)
function metersToKm(meters) {
  return Number((meters / 1000).toFixed(2));
}

// 📌 Start a trip
router.post("/start", auth, async (req, res) => {
  try {
    if (req.user.role !== "driver") {
      return res.status(403).json({ error: "Only drivers can start trips" });
    }

    const { vehicleId } = req.body;
    const today = new Date().toISOString().split("T")[0];

    const existingDriverTrip = await Trip.findOne({
      driverId: req.user.id,
      status: "ongoing"
    });
    if (existingDriverTrip) {
      return res.status(400).json({ error: "You already have an ongoing trip" });
    }

    const existingVehicleTrip = await Trip.findOne({
      vehicleId,
      status: "ongoing"
    });
    if (existingVehicleTrip) {
      return res.status(400).json({ error: "This vehicle is already in an ongoing trip" });
    }

    let trip = await Trip.findOne({ vehicleId, day: today });
    if (trip) {
      return res.status(400).json({ error: "Trip already started for this vehicle today" });
    }

    trip = new Trip({
      vehicleId,
      driverId: req.user.id,
      day: today,
      status: "ongoing",
      distanceTravelled: 0
    });

    await trip.save();
    res.json({ message: "Trip started", trip });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📌 Add live location
router.post("/location", auth, async (req, res) => {
  try {
    if (req.user.role !== "driver") {
      return res.status(403).json({ error: "Only drivers can send location" });
    }

    const { vehicleId, lat, lng, speed, heading, accuracy } = req.body;
    const today = new Date().toISOString().split("T")[0];

    let trip = await Trip.findOne({ vehicleId, day: today, status: "ongoing" });
    if (!trip) {
      return res.status(404).json({ error: "No ongoing trip found" });
    }

    // calculate distance from last point
    if (trip.route.length > 0) {
      const prev = trip.route[trip.route.length - 1];
      const dist = haversineDistance(
        { lat: prev.lat, lng: prev.lng },
        { lat, lng }
      );
      trip.distanceTravelled += dist;
    }

    // push new GPS point
    trip.route.push({ lat, lng, speed, heading, accuracy });
    await trip.save();

    // update vehicle's lastLocation
    await Vehicle.findByIdAndUpdate(vehicleId, {
      lastLocation: { lat, lng, timestamp: new Date() }
    });

    // 🔌 Emit live update to admins
    req.app.get("io").emit("liveLocation", {
      vehicleId,
      lat,
      lng,
      speed,
      heading,
      accuracy,
      distanceTravelled: metersToKm(trip.distanceTravelled), // in kms
      timestamp: new Date()
    });

    res.json({
      message: "Location updated",
      distanceTravelled: metersToKm(trip.distanceTravelled) // kms
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📌 End trip
router.post("/end", auth, async (req, res) => {
  try {
    if (req.user.role !== "driver") {
      return res.status(403).json({ error: "Only drivers can end trips" });
    }

    const { vehicleId } = req.body;
    const today = new Date().toISOString().split("T")[0];

    let trip = await Trip.findOne({ vehicleId, day: today, status: "ongoing" });
    if (!trip) {
      return res.status(404).json({ error: "No ongoing trip found" });
    }

    trip.status = "completed";
    trip.endTime = new Date();
    await trip.save();

    res.json({
      message: "Trip ended",
      trip: {
        ...trip.toObject(),
        distanceTravelled: metersToKm(trip.distanceTravelled) // kms
      }
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📌 Admin fetch trip history
router.get("/history/:vehicleId/:day", auth, async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ error: "Only admin can view trip history" });
    }

    const { vehicleId, day } = req.params;
    const trip = await Trip.findOne({ vehicleId, day })
      .populate("vehicleId", "name")
      .populate("driverId", "username");

    if (!trip) return res.status(404).json({ error: "No trip found" });

    res.json({
      ...trip.toObject(),
      distanceTravelled: metersToKm(trip.distanceTravelled)
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📌 Admin fetch live locations
router.get("/live", auth, async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ error: "Only admin can view live locations" });
    }

    const vehicles = await Vehicle.find({ status: "active" }).populate("driverId", "username");
    res.json(
      vehicles.map(v => ({
        vehicleId: v._id,
        name: v.name,
        driver: v.driverId ? v.driverId.username : null,
        lastLocation: v.lastLocation
      }))
    );
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📌 Admin fetch full route
router.get("/route/:vehicleId/:day", auth, async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ error: "Only admin can view trip routes" });
    }

    const { vehicleId, day } = req.params;
    const trip = await Trip.findOne({ vehicleId, day }, "route distanceTravelled")
      .populate("vehicleId", "name")
      .populate("driverId", "username");

    if (!trip) return res.status(404).json({ error: "No trip found" });

    res.json({
      ...trip.toObject(),
      distanceTravelled: metersToKm(trip.distanceTravelled)
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
