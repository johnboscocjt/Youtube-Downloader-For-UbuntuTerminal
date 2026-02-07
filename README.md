
# 🎥 YutubuDownload  
### *Tanzania-Optimized YouTube Downloader for Ubuntu Terminal*  

<div align="center">

```
╔══════════════════════════════════════════════════════════════════════════════╗
║                                                                              ║
║   Y   Y  U   U  TTTTT  U   U  B   B  U   U     DDDD   OOO   W   W  N   N    ║
║    Y Y   U   U    T    U   U  B   B  U   U     D   D O   O  W   W  NN  N    ║
║     Y    U   U    T    U   U  BBBB   U   U     D   D O   O  W W W  N N N    ║
║     Y    U   U    T    U   U  B   B  U   U     D   D O   O  WW WW  N  NN    ║
║     Y     UUU     T     UUU   BBBBB   UUU      DDDD   OOO   W   W  N   N    ║
║                                                                              ║
║          v1.0 • Fast • Reliable • Bot-Bypass • Resume Support                ║
║                Designed for Tanzania's Internet Conditions                   ║
╚══════════════════════════════════════════════════════════════════════════════╝
```

**Author:** Johnbosco | **Last Updated:** February 06, 2026  
🌍 *Tested across Dar es Salaam, Mwanza, Arusha & Zanzibar networks*  

[![GitHub Repo](https://img.shields.io/badge/GitHub-Repository-181717?logo=github)](https://github.com/johnboscocjt/Youtube-Downloader-For-UbuntuTerminal)  
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

</div>

> 💡 **Zsh users**: After install, run `source ~/.zshrc` once  
> 🌍 **Tanzania Tip**: Run during off-peak hours (after 10 PM EAT) for faster downloads!

---


## ⚡ One-Command Installation (Recommended)

```bash
# Installs ALL dependencies + script globally (run once)
sudo bash -c "$(curl -sL https://raw.githubusercontent.com/johnboscocjt/Youtube-Downloader-For-UbuntuTerminal/main/install.sh)"
```


## 🚀 Quick Start

```bash
# 1. CLOSE ALL CHROME WINDOWS COMPLETELY (required for cookie access)
# 2. Open terminal and run:
cd ~/youtubedownloading
YutubuDownload

# 3. Follow prompts:
#    • Paste YouTube URL
#    • Choose: Video or MP3
#    • Select quality (720p recommended for unstable networks)
#    • Confirm folder (recommended for playlists)
```

✅ **Done!** Files saved with resume support & no duplicates.

---

## ✨ Key Features

- **🇹🇿 Tanzania-Optimized**  
  Resume support for unstable 4G networks (Vodacom/Airtel/Tigo)
  
- **🛡️ Bot-Bypass Technology**  
  Uses Chrome cookies + user-agent spoofing to avoid "Sign in to confirm you're not a bot" errors
  
- **📁 Smart Organization**  
  Playlists saved as `Title [PLAYLIST_ID]` to prevent mixing same-name playlists (common with Bongo Flava compilations!)
  
- **🎵 Flexible Output**  
  Video (any resolution) or MP3 (320kbps/192kbps/128kbps)
  
- **💾 Data-Saving**  
  Never re-downloads completed videos (tracked in `~/yt-downloads-archive.txt`)
  
- **⚡ Deno-Powered**  
  Solves YouTube's 2026 JavaScript challenges for full quality access

---

## 🔧 Manual Installation (Alternative)

```bash
# 1. Install dependencies
sudo apt update && sudo apt install -y ffmpeg python3-venv python3-pip
sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp && sudo chmod a+rx /usr/local/bin/yt-dlp
curl -fsSL https://deno.land/install.sh | sh && echo 'export PATH="$HOME/.deno/bin:$PATH"' >> ~/.bashrc && source ~/.bashrc

# 2. Setup Python venv for cookies
mkdir -p ~/youtubedownloading && cd ~/youtubedownloading
python3 -m venv yt-venv && source yt-venv/bin/activate && pip install secretstorage cryptography && deactivate

# 3. Install script
sudo curl -sL https://raw.githubusercontent.com/johnboscocjt/Youtube-Downloader-For-UbuntuTerminal/main/YutubuDownload -o /usr/local/bin/YutubuDownload && sudo chmod +x /usr/local/bin/YutubuDownload
```


## 📚 Full Documentation

For detailed setup, troubleshooting, and advanced usage:  
👉 **[Complete Documentation](https://github.com/johnboscocjt/Youtube-Downloader-For-UbuntuTerminal/blob/main/YTdownloadScriptForVideoPlaylistAudio.md)**

---

---

### 🔧 How to Update from Terminal

After replacing the file on GitHub, update your local copy with:
```bash
sudo curl -sL "https://raw.githubusercontent.com/johnboscocjt/Youtube-Downloader-For-UbuntuTerminal/main/YutubuDownload?$(date +%s)" -o /usr/local/bin/YutubuDownload && sudo chmod +x /usr/local/bin/YutubuDownload
```
## OR: without cache bypassing

```bash
# Fetch latest version
sudo curl -sL https://raw.githubusercontent.com/johnboscocjt/Youtube-Downloader-For-UbuntuTerminal/main/YutubuDownload -o /usr/local/bin/YutubuDownload

# Make sure it's executable
sudo chmod +x /usr/local/bin/YutubuDownload
```



---

## ❓ Why Built for Tanzania?

> *"As a developer in Dar es Salaam, I created YutubuDownload to solve real problems Tanzanian users face daily:*  
> - *Mobile data is expensive → resume support saves money after disconnects*  
> - *Same-name playlists everywhere → ID-based folders prevent chaos*  
> - *YouTube aggressively blocks Tanzanian IPs → cookie + user-agent bypass works*  
> - *Power cuts interrupt downloads → archive tracking prevents duplicates*  
> *Tested on Vodacom 4G in Kariakoo, Airtel in Mwanza, and slow hotel Wi-Fi in Zanzibar."*  
> **— Johnbosco, Creator (February 2026)**

---

## 🤝 Support & Contribution

🐞 **Found a bug?** → [Open GitHub Issue](https://github.com/johnboscocjt/Youtube-Downloader-For-UbuntuTerminal/issues)  
💡 **Have an idea?** → Pull requests welcome!  
💬 **Tanzanian user community**: Join discussions on GitHub  

<div align="center">
  
⭐ **If this saves you time/data in Tanzania, please star the repo!**  
[![GitHub Stars](https://img.shields.io/github/stars/johnboscocjt/Youtube-Downloader-For-UbuntuTerminal?style=social)](https://github.com/johnboscocjt/Youtube-Downloader-For-UbuntuTerminal)  

*"YutubuDownload: Because slow internet shouldn't stop Tanzanian creators"*  
— Johnbosco, Dar es Salaam 🇹🇿  

</div>

