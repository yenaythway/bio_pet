
# 🐾 AI Pet Breed Identifier  
> **Instantly recognize dog and cat breeds using on-device, offline AI.**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
![Platform: Android/iOS](https://img.shields.io/badge/Platform-Mobile-blue)
![AI: On-Device](https://img.shields.io/badge/AI-On--Device-green)

---

## 🧐 Overview
AI Pet Breed Identifier helps you discover the **breed of any dog or cat** instantly using your camera or gallery.

The AI runs **directly on your device**, so the app works **offline**, responds **fast**, and keeps user data **private**.

This project is designed as a **real-world reference for Flutter AI/ML developers**, combining efficient ML models with smooth UI performance.

---

## ✨ Key Features
- 🐶 **AI Dog Breed Identifier** – Recognize hundreds of dog breeds  
- 🐱 **AI Cat Breed Identifier** – Classify cat breeds accurately  
- 🔌 **Offline Classification** – No internet required  
- 📸 **Camera & Gallery Support** – Live scan or upload photos  
- 📜 **Classification History** – Automatically save past results  
- 🌐 **Deep Dive** – Open detailed breed information in browser  

---

## 📸 Demo & Screenshots
![photo_2568-12-28 23 50 31](https://github.com/user-attachments/assets/42c91885-3f1b-4e36-a90e-1dc3c97a9237)

<p align="center">
  <video src="https://github.com/user-attachments/assets/78c58824-c3ca-487d-b7b9-1d0a141ea7b8" width="300" controls></video>
  <br>
  <em>App walkthrough and breed recognition demo</em>
</p>

---

## 🧠 AI Model: MobileNet
This app uses **MobileNet**, a lightweight and mobile-optimized deep learning model.

### Why MobileNet?
- ⚡ Fast inference on mobile devices  
- 📦 Small model size  
- 🔋 Low memory and battery usage  
- 📱 Ideal for on-device Flutter AI apps  

MobileNet provides a good balance between **speed and accuracy**, making it suitable for real-time pet breed recognition.

---

## 🚀 Flutter Performance: Isolate Inference
To avoid UI lag, AI inference runs inside a **Flutter Isolate**.

### Benefits of Isolate Inference
- 🧵 Heavy ML work runs in a separate thread  
- 🚫 Prevents UI freezing  
- 🎯 Smooth camera preview and scrolling  
- ⚡ Better user experience  

---

## 🧩 MobileNet + Isolate (Best Practice)
By combining **MobileNet** with **Isolate-based inference**, this app achieves:
- Real-time breed prediction  
- Efficient on-device AI  
- Smooth Flutter UI  
- A practical pattern for **Flutter AI/ML developers**

---

## 🛠️ How It Works
1. **Capture** – Use camera or select an image  
2. **Process** – MobileNet analyzes visual features (ears, coat, snout)  
3. **Inference** – Runs inside a Flutter Isolate  
4. **Result** – Breed is shown and saved to history  

---

## 🚀 Getting Started
### Prerequisites
- Android 8.0+ or iOS 13+
- Camera access

### Installation
1. Download the latest APK/Build from the **Releases** section  
2. Install on your device  
3. Grant camera permission when prompted  

---

## 🤝 Contributing
Contributions, issues, and feature requests are welcome.  
Feel free to check the **issues page**.

---

## 🛡️ License
This project is licensed under the **MIT License**.

---

<p align="center">
  Made with ❤️ for Pet Lovers & Flutter AI Developers
</p>
