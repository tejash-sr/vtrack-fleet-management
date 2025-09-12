const mongoose = require("mongoose");

const TripSchema = new mongoose.Schema({
  vehicleId: { type: mongoose.Schema.Types.ObjectId, ref: "Vehicle", required: true },
  driverId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },

  // 'YYYY-MM-DD' format for quick lookup by day
  day: { type: String, required: true, index: true },

  status: { type: String, enum: ["ongoing", "completed"], default: "ongoing" },
  startTime: { type: Date, default: Date.now },
  endTime: { type: Date },

  // total distance travelled in meters
  distanceTravelled: { type: Number, default: 0 },

  // 👇 actual GPS route points
  route: [
    {
      lat: Number,
      lng: Number,
      timestamp: { type: Date, default: Date.now }, // auto time for each point
      speed: Number,
      heading: Number,
      accuracy: Number,
    },
  ],
}, { timestamps: true });

// ensure unique trip per vehicle per day
TripSchema.index({ vehicleId: 1, day: 1 }, { unique: true });

module.exports = mongoose.model("Trip", TripSchema);
