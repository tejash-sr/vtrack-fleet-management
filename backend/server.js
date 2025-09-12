const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const http = require("http");
const { Server } = require("socket.io");
require('dotenv').config();

const app = express();
const server = http.createServer(app); // wrap express
const io = new Server(server, {
  cors: {
    origin: "*", // later restrict to your frontend domain
    methods: ["GET", "POST"]
  }
});

// Middleware
app.use(express.json());
app.use(cors());

// --- Inject io so routes can use it ---
app.set("io", io);

// Routes
const authRoutes = require('./routes/auth');
const dashboardRoutes = require("./routes/dashboard");
const tripRoutes = require("./routes/trip");
const vehicleRoutes = require("./routes/vehicles");

app.use("/api/auth", authRoutes);
app.use("/api/dashboard", dashboardRoutes);
app.use("/api/trips", tripRoutes);
app.use("/api/vehicles", vehicleRoutes);

// MongoDB
mongoose.connect(process.env.MONGO_URI, { useNewUrlParser: true, useUnifiedTopology: true })
  .then(() => console.log("MongoDB connected"))
  .catch(err => console.log(err));

// Test route
app.get('/', (req, res) => {
  res.send("FleetApp Backend Running");
});

// --- SOCKET.IO ---
io.on("connection", (socket) => {
  console.log("🔌 New client connected:", socket.id);

  socket.on("driverLocation", (data) => {
    console.log("📍 Driver Location:", data);
    io.emit("liveLocation", data); // send update to all clients
  });

  socket.on("disconnect", () => {
    console.log("❌ Client disconnected:", socket.id);
  });
});

// Start server
const PORT = process.env.PORT || 5000;
server.listen(PORT, () => console.log(`Server running on port ${PORT}`));
