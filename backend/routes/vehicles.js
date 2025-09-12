const express = require("express");
const router = express.Router();
const Vehicle = require("../models/Vehicle");
const User = require("../models/User");
const auth = require("../middleware/auth");

// 📌 Add vehicle (Admin only)
router.post("/", auth, async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ error: "Only admin can add vehicles" });
    }

    const { name, type, driverId } = req.body;

    // Validate driverId if provided
    if (driverId) {
      const driver = await User.findById(driverId);
      if (!driver || driver.role !== "driver") {
        return res.status(400).json({ error: "Invalid driver ID" });
      }
    }

    const newVehicle = new Vehicle({ name, type, driverId });
    await newVehicle.save();

    // Return populated vehicle with driver info
    const populatedVehicle = await Vehicle.findById(newVehicle._id).populate(
      "driverId",
      "username role"
    );

    res.json({ message: "Vehicle added successfully", vehicle: populatedVehicle });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📌 Get vehicles
router.get("/", auth, async (req, res) => {
  try {
    let vehicles;
    if (req.user.role === "admin") {
      // Admin sees all active vehicles
      vehicles = await Vehicle.find({ status: "active" }).populate(
        "driverId",
        "username role"
      );
    } else {
      // Driver sees only their assigned active vehicles
      vehicles = await Vehicle.find({
        driverId: req.user.id,
        status: "active",
      });
    }
    res.json(vehicles);
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📌 Assign driver to vehicle (Admin only)
router.put("/:vehicleId/assign-driver/:driverId", auth, async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ error: "Only admin can assign drivers" });
    }

    const { vehicleId, driverId } = req.params;

    const driver = await User.findById(driverId);
    if (!driver || driver.role !== "driver") {
      return res.status(400).json({ error: "Invalid driver ID" });
    }

    // 🚨 Check if driver already assigned to another active vehicle
    const existingVehicle = await Vehicle.findOne({
      driverId,
      status: "active",
      _id: { $ne: vehicleId }, // exclude current vehicle
    });
    if (existingVehicle) {
      return res.status(400).json({
        error: `Driver is already assigned to vehicle: ${existingVehicle.name}`,
      });
    }

    const vehicle = await Vehicle.findByIdAndUpdate(
      vehicleId,
      { driverId },
      { new: true }
    ).populate("driverId", "username role");

    if (!vehicle) {
      return res.status(404).json({ error: "Vehicle not found" });
    }

    res.json({ message: "Driver assigned successfully", vehicle });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// 📌 Unassign driver from vehicle (Admin only)
router.put("/:vehicleId/unassign-driver", auth, async (req, res) => {
  try {
    if (req.user.role !== "admin") {
      return res.status(403).json({ error: "Only admin can unassign drivers" });
    }

    const { vehicleId } = req.params;

    const vehicle = await Vehicle.findById(vehicleId);
    if (!vehicle) {
      return res.status(404).json({ error: "Vehicle not found" });
    }

    if (!vehicle.driverId) {
      return res.status(400).json({ error: "No driver is assigned to this vehicle" });
    }

    vehicle.driverId = null;
    await vehicle.save();

    res.json({ message: "Driver unassigned successfully", vehicle });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

module.exports = router;
