# VTrack Fleet Management - Integration Setup Script
# This script helps set up the integrated system

Write-Host "VTrack Fleet Management - Integration Setup" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

# Check if Node.js is installed
Write-Host "`nChecking Node.js installation..." -ForegroundColor Yellow
try {
    $nodeVersion = node --version
    Write-Host "Node.js version: $nodeVersion" -ForegroundColor Green
} catch {
    Write-Host "Node.js not found. Please install Node.js first." -ForegroundColor Red
    exit 1
}

# Check if Flutter is installed
Write-Host "`nChecking Flutter installation..." -ForegroundColor Yellow
try {
    $flutterVersion = flutter --version
    Write-Host "Flutter is installed" -ForegroundColor Green
} catch {
    Write-Host "Flutter not found. Please install Flutter first." -ForegroundColor Red
    exit 1
}

# Check if MongoDB is running
Write-Host "`nChecking MongoDB..." -ForegroundColor Yellow
try {
    $mongoStatus = Get-Service -Name "MongoDB" -ErrorAction SilentlyContinue
    if ($mongoStatus -and $mongoStatus.Status -eq "Running") {
        Write-Host "MongoDB is running" -ForegroundColor Green
    } else {
        Write-Host "MongoDB is not running. Please start MongoDB service." -ForegroundColor Red
        Write-Host "Run: net start MongoDB" -ForegroundColor Yellow
    }
} catch {
    Write-Host "MongoDB service not found. Please install MongoDB." -ForegroundColor Red
}

# Setup Backend
Write-Host "`nSetting up Backend..." -ForegroundColor Yellow
Set-Location "VTrack---Fleet-Management-App\backend"

# Install backend dependencies
Write-Host "Installing backend dependencies..." -ForegroundColor Cyan
npm install

# Create .env file
Write-Host "Creating .env file..." -ForegroundColor Cyan
$envContent = @"
MONGO_URI=mongodb://localhost:27017/fleet_management
JWT_SECRET=your_jwt_secret_key_here_change_this_in_production
PORT=5000
"@
$envContent | Out-File -FilePath ".env" -Encoding UTF8

Write-Host "Backend setup complete!" -ForegroundColor Green

# Setup Driver App
Write-Host "`nSetting up Driver App..." -ForegroundColor Yellow
Set-Location "..\driver_app"

# Install Flutter dependencies
Write-Host "Installing driver app dependencies..." -ForegroundColor Cyan
flutter pub get

Write-Host "Driver app setup complete!" -ForegroundColor Green

# Setup Manager Dashboard
Write-Host "`nSetting up Manager Dashboard..." -ForegroundColor Yellow
Set-Location "..\manager_dashboard"

# Install Flutter dependencies
Write-Host "Installing manager dashboard dependencies..." -ForegroundColor Cyan
flutter pub get

Write-Host "Manager dashboard setup complete!" -ForegroundColor Green

# Return to root directory
Set-Location ".."

Write-Host "`n=============================================" -ForegroundColor Green
Write-Host "Setup Complete!" -ForegroundColor Green
Write-Host "=============================================" -ForegroundColor Green

Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "1. Start MongoDB service: net start MongoDB" -ForegroundColor White
Write-Host "2. Start Backend: cd backend && npm start" -ForegroundColor White
Write-Host "3. Start Driver App: cd driver_app && flutter run" -ForegroundColor White
Write-Host "4. Start Manager Dashboard: cd manager_dashboard && flutter run -d chrome" -ForegroundColor White

Write-Host "`nDefault Credentials:" -ForegroundColor Yellow
Write-Host "Manager: admin / admin123" -ForegroundColor White
Write-Host "Driver: driver1 / driver123" -ForegroundColor White

Write-Host "`nFor detailed instructions, see INTEGRATION_GUIDE.md" -ForegroundColor Cyan

