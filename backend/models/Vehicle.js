const mongoose = require("mongoose");

const VehicleSchema = new mongoose.Schema({
  name: { type: String, required: true, unique: true },   // e.g. "TN01AB1234"
  type: { type: String, required: true },                 // e.g. "Truck", "Van"
  driverId: { type: mongoose.Schema.Types.ObjectId, ref: "User", default: null },
  status: { type: String, enum: ["active", "inactive"], default: "active" },

  // 👇 last live location (used for admin dashboard map)
  lastLocation: {
    lat: { type: Number },
    lng: { type: Number },
    timestamp: { type: Date }
  }
});

module.exports = mongoose.model("Vehicle", VehicleSchema);
