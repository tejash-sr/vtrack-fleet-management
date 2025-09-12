# 🚛 VTrack Fleet Management System

A comprehensive Fleet Management System built with **Flutter** and **Node.js/Express**, featuring real-time GPS tracking, expense management, and SOS alerts.

## 🛠 Tech Stack

- **Backend**: Node.js/Express + MongoDB + Socket.io
- **Driver App**: Flutter (Android/Web)
- **Manager Dashboard**: Flutter Web/Desktop
- **Maps**: OpenStreetMap (free)
- **Real-time**: Socket.io for live updates
- **Authentication**: JWT-based with username/password

## 📱 Features

### Driver App (Android/Web)
- ✅ Username/password authentication
- ✅ Real-time GPS tracking
- ✅ Trip management (start/end with route tracking)
- ✅ Vehicle assignment checking
- ✅ Expense tracking with photo receipts
- ✅ SOS emergency alerts
- ✅ Clean, intuitive UI

### Manager Dashboard (Web/Desktop)
- ✅ Admin authentication
- ✅ Driver management (add new drivers)
- ✅ Vehicle management and assignment
- ✅ Real-time fleet map with OpenStreetMap
- ✅ Live driver location tracking
- ✅ Trip history and analytics
- ✅ Excel export functionality
- ✅ Responsive design

## 🚀 Quick Start

### Option 1: Automated Setup (Windows)
```powershell
# Run the setup script
.\setup_integration.ps1
```

### Option 2: Manual Setup

#### 1. Backend Setup
```bash
cd backend
npm install
echo "MONGO_URI=mongodb://localhost:27017/fleet_management
JWT_SECRET=your_jwt_secret_key_here_change_this_in_production
PORT=5000" > .env
npm start
```

#### 2. Driver App
```bash
cd driver_app
flutter pub get
flutter run
```

#### 3. Manager Dashboard
```bash
cd manager_dashboard
flutter pub get
flutter run -d chrome
```

### Prerequisites
- Node.js (v14+)
- Flutter (v3.0+)
- MongoDB (running locally)

## 📁 Project Structure

```
VTrack---Fleet-Management-App/
├── backend/                       # Node.js/Express API
│   ├── models/                    # MongoDB models
│   ├── routes/                    # API routes
│   ├── middleware/                # Auth middleware
│   └── server.js                  # Main server file
├── driver_app/                    # Flutter Driver App
├── manager_dashboard/             # Flutter Manager Dashboard
├── INTEGRATION_GUIDE.md           # Detailed setup guide
├── setup_integration.ps1          # Windows setup script
└── README.md
```

## 🔧 Configuration

### Backend Services Required
- **MongoDB** (local or cloud)
- **Node.js/Express** API server
- **Socket.io** for real-time updates
- **JWT** for authentication

### Environment Setup
1. Install MongoDB and start service
2. Install Node.js dependencies
3. Configure environment variables
4. Start backend server
5. Run Flutter apps

## 📊 Database Structure

### MongoDB Collections
- `users/` - User accounts (drivers and admins)
- `vehicles/` - Fleet vehicles with assignments
- `trips/` - Trip records with GPS routes
- `expenses/` - Expense tracking with photos
- `alerts/` - SOS and emergency alerts

### Real-time Updates
- Socket.io for live location updates
- Real-time trip status changes
- Live SOS alert notifications

## 🔐 Security

- JWT-based authentication with role-based access
- Password hashing with bcrypt
- API endpoint protection with middleware
- Secure data transmission over HTTPS

## 📈 Demo

### Test Accounts
**Manager/Admin:**
- Username: `admin`
- Password: `admin123`

**Driver:**
- Username: `driver1`
- Password: `driver123`

### Demo Flow
1. Manager Dashboard overview
2. Driver login and trip start
3. Real-time location tracking
4. Expense addition with photo
5. SOS alert and response
6. Data export functionality

## 🏗 Build & Deploy

### Driver App (APK)
```bash
flutter build apk --release
# APK location: build/app/outputs/flutter-apk/app-release.apk
```

### Manager Dashboard (Web)
```bash
flutter build web --release
firebase deploy --only hosting
```

## 📋 Documentation

- [Integration Guide](INTEGRATION_GUIDE.md) - Detailed setup and configuration
- [Build Commands](BUILD_COMMANDS.md)
- [Demo Script](DEMO_SCRIPT.md)
- [Project Structure](PROJECT_STRUCTURE.md)

## 🧪 Testing

### Driver App Testing
- Username/password authentication
- GPS location accuracy
- Trip management flow
- Vehicle assignment checking
- SOS alert system

### Manager Dashboard Testing
- Admin authentication
- Driver management
- Real-time map updates
- Data export functionality
- Responsive design

## 🔄 Development Workflow

1. **Setup**: Clone repo and start MongoDB
2. **Backend**: Start Node.js server with `npm start`
3. **Frontend**: Use Flutter hot reload for rapid development
4. **Testing**: Run on physical devices for accurate testing
5. **Build**: Generate APK and web builds
6. **Deploy**: Deploy to your preferred hosting platform

## 📱 Supported Platforms

- **Android**: API 21+ (Android 5.0+)
- **Web**: Modern browsers (Chrome, Firefox, Safari, Edge)
- **iOS**: Compatible (requires iOS configuration)

## 🚨 SOS Alert System

- Real-time emergency notifications
- Automatic location sharing
- Manager dashboard alerts with sound
- Emergency contact integration
- Alert resolution tracking

## 💰 Cost Considerations

- **MongoDB**: Free local installation or MongoDB Atlas free tier
- **Node.js**: Free and open-source
- **OpenStreetMap**: Free map tiles
- **Development**: Flutter is free and open-source
- **Hosting**: Deploy to any cloud provider

## 🔮 Future Enhancements

- Push notifications
- Advanced analytics dashboard
- Route optimization
- Fuel efficiency tracking
- Maintenance scheduling
- Driver performance metrics

## 🤝 Contributing

1. Fork the repository
2. Create feature branch
3. Commit changes
4. Push to branch
5. Create Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
1. Check the documentation
2. Review Firebase Console logs
3. Check Flutter logs: `flutter logs`
4. Create an issue in the repository

## 🎯 Key Benefits

- **Real-time Tracking**: Live fleet monitoring with Socket.io
- **Cost Effective**: Free map tiles, open-source backend
- **Scalable**: MongoDB and Node.js scale easily
- **Secure**: JWT authentication and role-based access
- **Easy Setup**: Automated setup script available
- **Cross-platform**: Android + Web + Desktop
- **Manager Control**: Only managers can add new drivers

---

**Built with ❤️ using Flutter & Node.js/Express**
