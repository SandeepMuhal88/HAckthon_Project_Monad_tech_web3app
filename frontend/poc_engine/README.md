# 🚀 CryptoWallet - Web3 Crypto Trading App

एक **modern और feature-rich cryptocurrency wallet application** जो Flutter और Web3 के साथ बनाया गया है।

## ✨ Features

### 💰 Wallet Management
- **Create Wallet**: नया wallet automatically generate करें
- **Import Wallet**: पुराना wallet private key से import करें
- **Secure Storage**: Private keys encrypted secure storage में save होती हैं
- **Balance Tracking**: Real-time wallet balance देखें

### 📊 Crypto Tracking
- **Real-time Prices**: CoinGecko API से live cryptocurrency prices
- **50+ Cryptocurrencies**: Bitcoin, Ethereum, और बाकी top coins
- **Trending Section**: सबसे ज़्यादा gain करने वाली coins
- **Price Charts**: Mini charts और detailed history
- **Market Data**: Market cap, 24h volume, price changes

### 💱 Trading Features
- **Token Swap Interface**: Crypto tokens को swap करने का UI
- **Coin Selection**: सभी available tokens से select करें
- **Swap Confirmation**: Transaction confirm करने से पहले review करें

### 🔐 Security
- **Encrypted Storage**: Flutter Secure Storage के साथ
- **Private Key Protection**: Keys device पर encrypted रहती हैं
- **No Backend Storage**: सभी data locally store होता है

### 🌐 Blockchain Integration
- **Monad Testnet**: Monad blockchain के साथ integrated
- **Web3 Support**: web3dart library के साथ
- **Send/Receive**: Tokens भेजें और प्राप्त करें
- **Transaction History**: (Coming soon)

## 🎨 UI/UX Features

- **Dark Theme**: Modern gradient-based dark theme
- **Smooth Animations**: Transitions और micro-animations
- **Responsive Design**: सभी screen sizes के लिए optimized
- **Material Design 3**: Latest Material Design guidelines
- **Custom Fonts**: Google Fonts (Inter) के साथ
- **Glassmorphism Effects**: Premium look और feel

## 📱 Screenshots

### Home Screen
- Wallet balance overview
- Quick actions (Send, Receive, Swap)
- Trending cryptocurrencies
- All coins list

### Trading Screen
- Token swap interface
- Real-time price conversion
- Coin selection modal

### Settings
- Wallet management
- Network status
- Export private key
- Delete wallet

## 🛠️ Tech Stack

### Frontend
- **Flutter** - Cross-platform framework
- **Dart** - Programming language

### State Management
- **Provider** - State management solution

### Blockchain
- **web3dart** - Web3 Ethereum library for Dart
- **Monad Testnet** - Blockchain network

### APIs
- **CoinGecko API** - Cryptocurrency prices और market data

### Storage
- **Flutter Secure Storage** - Encrypted local storage
- **Shared Preferences** - App preferences

### UI Libraries
- **Google Fonts** - Custom typography
- **FL Chart** - Charts और graphs
- **Syncfusion Charts** - Advanced charting
- **Shimmer** - Loading effects
- **QR Flutter** - QR code generation

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.0.0)
- Dart SDK
- Windows/macOS/Linux development environment

### Installation

1. **Clone the repository**
```bash
cd d:\PROGRAMMING\LNM_HACKS_8.0_Hackethon\frontend\poc_engine
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Run the app**
```bash
# For Windows
flutter run -d windows

# For Android
flutter run -d android

# For iOS
flutter run -d ios

# For Web
flutter run -d chrome
```

## 📖 Usage Guide

### Creating a New Wallet

1. App खोलें
2. Home screen पर "Create Wallet" button पर click करें
3. Wallet automatically generate हो जाएगा
4. **Important**: Settings में जाकर private key backup कर लें!

### Importing Existing Wallet

1. Home screen पर wallet setup modal खोलें
2. "Import Wallet" select करें
3. अपनी private key enter करें
4. Import button पर click करें

### Sending Crypto

1. Home screen पर "Send" button click करें
2. Recipient का wallet address enter करें
3. Amount enter करें
4. Transaction confirm करें

### Receiving Crypto

1. Home screen पर "Receive" button click करें
2. अपना wallet address copy करें
3. QR code scan करवाएं या address share करें

### Token Swapping

1. Bottom navigation में Swap icon पर click करें
2. "From" token select करें
3. "To" token select करें
4. Amount enter करें
5. "Swap" button click करें

## 🔒 Security Best Practices

⚠️ **IMPORTANT SECURITY NOTES**:

1. **Never share your private key** किसी के साथ भी
2. **Backup your private key** safely एक secure location में
3. **Use only on testnet** - यह app currently Monad Testnet के लिए है
4. **Keep your device secure** - Malware और unauthorized access से बचें

## 🌐 Network Configuration

### Monad Testnet
- **RPC URL**: https://testnet-rpc.monad.xyz/
- **Chain ID**: 41454
- **Currency**: MON (Test tokens)

## 📂 Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # Main app widget
├── screens/
│   ├── splash_screen.dart    # Splash/loading screen
│   ├── home_screen.dart      # Main dashboard
│   ├── trading_screen.dart   # Token swap interface
│   ├── wallet_screen.dart    # Wallet details
│   ├── portfolio_screen.dart # Portfolio management
│   └── settings_screen.dart  # App settings
├── services/
│   ├── wallet_service.dart   # Web3 wallet management
│   └── crypto_service.dart   # Crypto price data
└── widgets/
    ├── crypto_card.dart      # Cryptocurrency list item
    └── trending_coin_card.dart # Trending coin card
```

## 🔄 State Management Flow

```
Provider (Root)
├── WalletService
│   ├── Wallet creation/import
│   ├── Balance tracking
│   └── Transaction sending
└── CryptoService
    ├── Price fetching (CoinGecko API)
    ├── Trending coins
    └── Historical data
```

## 🎯 Future Enhancements

- [ ] **Portfolio Tracking**: Holdings और P&L tracking
- [ ] **Transaction History**: सभी past transactions
- [ ] **DEX Integration**: Actual token swapping
- [ ] **Multi-chain Support**: Multiple blockchains
- [ ] **NFT Gallery**: NFT viewing और management
- [ ] **DApp Browser**: In-app Web3 browser
- [ ] **Staking**: Token staking features
- [ ] **Price Alerts**: Custom price notifications
- [ ] **Biometric Security**: Fingerprint/Face ID
- [ ] **Multi-language**: Hindi, English, और अन्य languages

## 🐛 Known Issues

- Token swap is simulation-based (DEX integration pending)
- QR code generation shows placeholder icon
- Network connection required for price updates

## 📝 Environment Variables

Create a `.env` file (optional for advanced configuration):

```env
MONAD_RPC_URL=https://testnet-rpc.monad.xyz/
CHAIN_ID=41454
```

## 🤝 Contributing

Contributions welcome हैं! Please follow these steps:

1. Fork the repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License.

## 👨‍💻 Developer

Built with ❤️ for LNM Hacks 8.0 Hackathon

## 🙏 Acknowledgments

- **CoinGecko** - Cryptocurrency price data
- **Monad** - Blockchain infrastructure
- **Flutter Team** - Amazing framework
- **web3dart** - Web3 integration

## 📞 Support

Issues के लिए GitHub Issues का use करें या documentation check करें।

---

**⚡ Happy Trading! ⚡**
