# VTrack Fleet Management - Integration Guide

## Overview
This guide explains how to run the integrated VTrack Fleet Management system with backend API and Flutter frontend applications.

## Architecture

### Backend (Node.js + MongoDB)
- **Authentication**: JWT-based with username/password
- **Database**: MongoDB for data persistence
- **Real-time**: Socket.io for live location updates
- **API**: RESTful endpoints for all operations

### Frontend (Flutter)
- **Driver App**: Mobile app for drivers to manage trips
- **Manager Dashboard**: Web/Desktop app for fleet management
- **Authentication**: Backend API integration
- **Real-time**: Socket.io for live updates

## Setup Instructions

### 1. Backend Setup

```bash
cd VTrack---Fleet-Management-App/backend

# Install dependencies
npm install

# Create .env file
echo "MONGO_URI=mongodb://localhost:27017/fleet_management
JWT_SECRET=your_jwt_secret_key_here_change_this_in_production
PORT=5000" > .env

# Start MongoDB (make sure MongoDB is running)
# On Windows: net start MongoDB
# On macOS: brew services start mongodb-community
# On Linux: sudo systemctl start mongod

# Start the backend server
npm start
```

### 2. Driver App Setup

```bash
cd VTrack---Fleet-Management-App/driver_app

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### 3. Manager Dashboard Setup

```bash
cd VTrack---Fleet-Management-App/manager_dashboard

# Install dependencies
flutter pub get

# Run the app
flutter run -d chrome  # For web
# or
flutter run  # For desktop
```

## API Endpoints

### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/signup` - Add new driver (admin only)

### Vehicles
- `GET /api/vehicles` - Get vehicles
- `POST /api/vehicles` - Add vehicle (admin only)
- `PUT /api/vehicles/:id/assign-driver/:driverId` - Assign driver
- `PUT /api/vehicles/:id/unassign-driver` - Unassign driver

### Trips
- `POST /api/trips/start` - Start trip
- `POST /api/trips/location` - Update location
- `POST /api/trips/end` - End trip
- `GET /api/trips/live` - Get live locations
- `GET /api/trips/route/:vehicleId/:day` - Get trip route

### Dashboard
- `GET /api/dashboard/summary` - Get dashboard summary
- `GET /api/dashboard/live-vehicles` - Get live vehicles
- `GET /api/dashboard/trip-history/:vehicleId/:day` - Get trip history

## Default Credentials

### Manager/Admin
- Username: `admin`
- Password: `admin123`

### Driver
- Username: `driver1`
- Password: `driver123`

## Key Features

### Driver App
- ✅ Username/password authentication
- ✅ Vehicle assignment checking
- ✅ Trip management (start/end)
- ✅ Real-time location tracking
- ✅ Route visualization
- ✅ SOS alerts

### Manager Dashboard
- ✅ Admin authentication
- ✅ Driver management (add drivers)
- ✅ Vehicle management
- ✅ Live fleet tracking
- ✅ Trip history and analytics
- ✅ Real-time updates

## Data Flow

1. **Authentication**: Both apps use backend API for login
2. **Trip Management**: Driver starts trip → Backend creates trip record → Real-time location updates
3. **Fleet Tracking**: Manager views live locations via Socket.io
4. **Data Persistence**: All data stored in MongoDB via backend API

## Firebase vs API Usage

### Backend API (Primary)
- User authentication
- Trip management
- Vehicle management
- Data persistence
- Business logic

### Firebase (Secondary)
- Real-time notifications
- SOS alerts
- Push notifications
- File storage (if needed)

## Troubleshooting

### Common Issues

1. **Backend not starting**
   - Check if MongoDB is running
   - Verify .env file exists
   - Check port 5000 is available

2. **Authentication failing**
   - Verify backend is running on port 5000
   - Check API service base URL
   - Ensure JWT secret is set

3. **Location not updating**
   - Check location permissions
   - Verify GPS is enabled
   - Check network connectivity

### Development Tips

1. **Backend Development**
   - Use `npm run dev` for auto-restart
   - Check MongoDB Compass for data
   - Monitor console logs

2. **Frontend Development**
   - Use Flutter Inspector for debugging
   - Check network requests in DevTools
   - Test on different screen sizes

## Production Deployment

### Backend
- Use PM2 for process management
- Set up MongoDB Atlas for cloud database
- Configure environment variables
- Set up SSL certificates

### Frontend
- Build for production
- Deploy to app stores (mobile)
- Deploy to web hosting (dashboard)

## Security Considerations

- Change default JWT secret
- Use HTTPS in production
- Implement rate limiting
- Add input validation
- Secure MongoDB access

