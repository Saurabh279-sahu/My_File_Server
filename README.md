# 🚀 My File Server

A lightweight browser-based **LAN File Server** for sharing files from a computer or Android device over a local network.

The project is designed to be simple to start and easy to use: run the server, open the displayed address in a browser, and access the shared files from another device on the same network.

## ✨ Features

- 📁 Browser-based file and folder access
- 📤 File upload
- 📥 File download
- 🖼️ Media/file preview
- 🎬 Browser-based media playback where supported by the browser
- 🌐 LAN access
- 📱 Android + Termux friendly
- 💻 Node.js compatible environments
- ⚡ Simple `server.sh` launcher
- 🔐 Protected server runtime in the public package

> **Default port:** `1234`

---

## 📋 Requirements

You need:

- Node.js
- A terminal
- A device connected to your local network

For Android, the recommended terminal environment is **Termux**.

Check Node.js:

```bash
node --version
```

---

# 🚀 Quick Start

## 1. Clone the repository

```bash
git clone git@github.com:Saurabh279-sahu/My_File_Server.git
cd My_File_Server
```

Replace `YOUR-USERNAME` with the GitHub username that owns the repository.

If you downloaded the repository as a ZIP instead, extract it and open a terminal inside the extracted folder.

## 2. Start the server

Run:

```bash
bash server.sh
```

The launcher automatically downloads the latest protected server package from the GitHub Releases page on first run.

The server uses port `1234` by default.

You should see the local/LAN address printed in the terminal.

Example:

```text
Local: http://localhost:1234
LAN:   http://192.168.1.10:1234
```

---

# 🌐 Open the Server

### On the same device

Open:

```text
http://localhost:1234
```

### From another phone or laptop

Connect both devices to the same Wi-Fi/LAN and open the LAN address shown by the server.

Example:

```text
http://192.168.1.10:1234
```

Do **not** use `localhost` on the second device.

`localhost` always means the device on which the browser itself is running.

---

# 📱 Android / Termux

You can run the server directly on Android using Termux.

## 1. Give Termux storage permission

```bash
termux-setup-storage
```

Allow the Android permission when requested.

## 2. Enter the project directory

For example, if the project is in Downloads:

```bash
cd ~/storage/downloads/My-File-Server
```

## 3. Start the server

```bash
bash server.sh
```

Then open the LAN address shown in the terminal.

---

# 📂 Shared Directory

The server exposes the directory configured by the server package.

Before starting the server, check which folder is being shared and make sure it does not contain private information.

Do **not** intentionally place sensitive data in a publicly accessible shared directory, such as:

- Password files
- SSH private keys
- API keys
- Banking documents
- Private documents
- Personal backups

---

# 📤 Upload Files

Open the server web interface in your browser.

Use the available upload controls to select files from the client device.

For large files:

- Keep the server running.
- Keep the browser tab open.
- Avoid switching networks during the upload.
- Make sure enough storage is available on the server device.

---

# 📥 Download Files

Browse to the required file through the web interface and use the available download action.

Transfers happen through the local network when the client and server are on the same LAN.

---

# 🎬 Media and File Preview

The browser can preview supported file types.

Actual playback/preview support depends on the browser and file format.

For example, modern browsers commonly support many:

```text
.jpg
.jpeg
.png
.webp
.mp4
.webm
.pdf
```

Unsupported files can generally be downloaded and opened with an appropriate application.

---

# 🔌 Port

The default port is:

```text
1234
```

The normal URL is:

```text
http://DEVICE-IP:1234
```

Example:

```text
http://192.168.1.10:1234
```

If the port is already occupied, stop the other service using that port or use a port option supported by the installed server version.

---

# 🛑 Stop the Server

Go to the terminal running the server and press:

```text
CTRL + C
```

The server will stop.

---

# 🧰 Troubleshooting

## `node: command not found`

Node.js is not available in the current terminal.

Install a compatible Node.js version and verify:

```bash
node --version
```

Then run:

```bash
bash server.sh
```

---

## Other devices cannot connect

Check:

### 1. Same network

Both devices should normally be connected to the same Wi-Fi/LAN.

### 2. Correct LAN address

Use the LAN address printed by the server.

Example:

```text
http://192.168.1.10:1234
```

### 3. Firewall

A firewall may block incoming connections to the selected port.

### 4. Hotspot isolation

Some mobile hotspots prevent connected devices from communicating with each other.

---

## Port is already in use

If port `1234` is already occupied, the server may fail to start.

Find and stop the application using that port, or configure/use another supported port.

---

# 🔐 Security

This project is primarily intended for **trusted local networks**.

Do not expose the server directly to the public Internet unless you have added and configured appropriate authentication, access control, firewall rules, and other security protections.

Anyone who can reach an exposed file server may be able to access files that the server makes available.

### Important

A protected/obfuscated JavaScript runtime is **not encryption** and does not make the application impossible to reverse-engineer.

The public package is designed to make casual source inspection harder, but determined users may still be able to analyze executable JavaScript.

Never put secrets such as:

```text
API keys
Passwords
Private tokens
SSH private keys
Database credentials
```

inside the distributed server.

---

# 🗂️ Project Structure

```text
My-File-Server/
│
├── README.md
├── LICENSE
├── .gitignore
├── server.sh
│
└── server.sh

# The protected runtime is downloaded automatically from GitHub Releases.
```

### `server.sh`

The simple launcher used to start the server:

```bash
bash server.sh
```

### `release/server_v9_protected.js`

The protected server runtime used by the launcher.

---

# 🧑‍💻 Development

The public repository intentionally does not contain the original readable private source implementation.

If you are maintaining the project, keep your original development source in a **private location/repository** and publish only the files intended for distribution.

Before every public push, verify that no private source, credentials, keys, backups, or temporary files are included.

Useful check:

```bash
git status
```

You can also inspect tracked files:

```bash
git ls-files
```

---

# 📜 License

Copyright © 2026 Saurabh Sahu.

All rights reserved.

See the `LICENSE` file for the complete terms.

---

# ⭐ Support

If you find this project useful:

- ⭐ Star the repository
- 🐛 Report reproducible bugs
- 💡 Suggest useful features
- 📖 Improve documentation

---

## 👨‍💻 Author

**Saurabh Sahu**

My File Server — simple LAN file sharing through a web browser.

