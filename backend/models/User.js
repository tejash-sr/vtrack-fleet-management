const mongoose = require("mongoose");

const UserSchema = new mongoose.Schema({
  username: {
    type: String,
    required: true,
    unique: true   // ✅ unique on username only
  },
  password: {
    type: String,
    required: true
  },
  role: {
    type: String,
    enum: ["driver", "admin"],
    default: "driver"
  }
});

module.exports = mongoose.model("User", UserSchema);
