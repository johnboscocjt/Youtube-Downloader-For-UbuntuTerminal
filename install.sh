#!/usr/bin/env bash
# YutubuDownload Installer - Tanzania-Optimized YouTube Downloader
# Author: Johnbosco | Updated: February 08, 2026
# GitHub: https://github.com/johnboscocjt/Youtube-Downloader-For-UbuntuTerminal

# Exit on critical errors only
set -uo pipefail

# === ANIMATED LOADING FUNCTION (GREEN) ===
print_loading() {
    local msg="$1"
    echo -ne "\033[38;5;46m$msg\033[0m"
    for _ in {1..5}; do
        echo -ne "."
        sleep 0.3
    done
    echo -e " ✅\033[0m"
}

# Function to check if deno is installed (for any user)
check_deno_installed() {
    # Check if deno is in PATH for current user
    if command -v deno &> /dev/null; then
        return 0
    fi
    
    # Check if deno is in common locations
    local deno_paths=(
        "/usr/local/bin/deno"
        "/usr/bin/deno"
        "/bin/deno"
        "/root/.deno/bin/deno"
    )
    
    for path in "${deno_paths[@]}"; do
        if [ -f "$path" ]; then
            return 0
        fi
    done
    
    # Check if regular user has deno
    local current_user="${SUDO_USER:-$USER}"
    if [ -n "$current_user" ] && [ "$current_user" != "root" ]; then
        local user_home=$(eval echo "~$current_user")
        if [ -f "$user_home/.deno/bin/deno" ]; then
            return 0
        fi
    fi
    
    return 1
}

# Function to get deno version if available
get_deno_version() {
    if command -v deno &> /dev/null; then
        deno --version 2>/dev/null | head -1 | awk '{print $2}' 2>/dev/null || echo "installed"
    elif [ -f "/usr/local/bin/deno" ]; then
        /usr/local/bin/deno --version 2>/dev/null | head -1 | awk '{print $2}' 2>/dev/null || echo "installed"
    elif [ -f "/root/.deno/bin/deno" ]; then
        /root/.deno/bin/deno --version 2>/dev/null | head -1 | awk '{print $2}' 2>/dev/null || echo "installed"
    else
        local current_user="${SUDO_USER:-$USER}"
        if [ -n "$current_user" ] && [ "$current_user" != "root" ]; then
            local user_home=$(eval echo "~$current_user")
            if [ -f "$user_home/.deno/bin/deno" ]; then
                "$user_home/.deno/bin/deno" --version 2>/dev/null | head -1 | awk '{print $2}' 2>/dev/null || echo "installed"
            fi
        fi
    fi
}

# Check root privileges
if [[ $EUID -ne 0 ]]; then
    echo "❌ ERROR: This installer requires root privileges."
    echo "   Run with:"
    echo "   sudo bash -c '\$(curl -sL https://raw.githubusercontent.com/johnboscocjt/Youtube-Downloader-For-UbuntuTerminal/main/install.sh)'"
    exit 1
fi

echo ""
cat << 'EOF'

                    ▖▖  ▗   ▌   ▄        ▜      ▌
                    ▌▌▌▌▜▘▌▌▛▌▌▌▌▌▛▌▌▌▌▛▌▐ ▛▌▀▌▛▌
                    ▐ ▙▌▐▖▙▌▙▌▙▌▙▘▙▌▚▚▘▌▌▐▖▙▌█▌▙▌
                                                                                                                                       
EOF
echo "        Y U T U B U D O W N L O A D   I N S T A L L E R                  "
echo "            Tanzania-Optimized • v1.0 • Feb 08, 2026                   "
echo ""

# Helper function to check if package is installed
is_installed() {
    dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -q "install ok installed"
}

# Helper function to wait for apt lock
wait_for_apt_lock() {
    local timeout=30
    local count=0
    while sudo fuser /var/lib/dpkg/lock-frontend /var/lib/dpkg/lock >/dev/null 2>&1 && [ $count -lt $timeout ]; do
        if [ $count -eq 0 ]; then
            echo "   ⏳ Waiting for package manager to become available..."
        fi
        sleep 2
        ((count+=2))
    done
    if [ $count -ge $timeout ]; then
        echo "   ⚠️  Warning: Package manager still locked after 30s. Proceeding anyway..."
    fi
}

# STEP 1: System dependencies
echo "📦 STEP 1/5: Checking system dependencies..."
wait_for_apt_lock

if [ ! -f /var/cache/apt/pkgcache.bin ] || [ "$(find /var/cache/apt/pkgcache.bin -mmin +1440 2>/dev/null)" ]; then
    print_loading "   ↻ Updating package lists"
    apt-get update -qq > /dev/null 2>&1 || echo "   ⚠️  Warning: apt update failed (continuing anyway)"
fi

MISSING_PKGS=()
for pkg in ffmpeg python3-venv python3-pip; do
    if is_installed "$pkg"; then
        echo "   ✅ $pkg already installed"
    else
        MISSING_PKGS+=("$pkg")
    fi
done

if [ ${#MISSING_PKGS[@]} -gt 0 ]; then
    echo "   ⬇️  Installing missing packages: ${MISSING_PKGS[*]}..."
    DEBIAN_FRONTEND=noninteractive apt-get install -y -qq "${MISSING_PKGS[@]}" > /dev/null 2>&1
    if is_installed "${MISSING_PKGS[0]}"; then
        echo "   ✅ System dependencies installed"
    else
        echo "   ❌ FAILED to install dependencies. Try manually:"
        echo "      sudo apt install -y ${MISSING_PKGS[*]}"
        exit 1
    fi
else
    echo "   ✅ All system dependencies already installed"
fi

# STEP 2: yt-dlp
echo ""
echo "📦 STEP 2/5: Checking yt-dlp..."
if command -v yt-dlp &> /dev/null && yt-dlp --version &> /dev/null; then
    echo "   ✅ yt-dlp already installed ($(yt-dlp --version | head -1))"
else
    print_loading "   ⬇️  Installing yt-dlp"
    curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp > /dev/null 2>&1
    chmod a+rx /usr/local/bin/yt-dlp > /dev/null 2>&1
    if command -v yt-dlp &> /dev/null; then
        echo "   ✅ yt-dlp installed to /usr/local/bin/yt-dlp"
    else
        echo "   ❌ FAILED to install yt-dlp. Try manually:"
        echo "      sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp"
        echo "      sudo chmod a+rx /usr/local/bin/yt-dlp"
        exit 1
    fi
fi

# STEP 3: Deno - IMPROVED DETECTION
echo ""
echo "📦 STEP 3/5: Checking Deno (JavaScript runtime)..."
CURRENT_USER="${SUDO_USER:-$USER}"
USER_HOME=""
if [ -n "$CURRENT_USER" ] && [ "$CURRENT_USER" != "root" ]; then
    USER_HOME=$(eval echo "~$CURRENT_USER")
fi

if check_deno_installed; then
    DENO_VERSION=$(get_deno_version)
    echo "   ✅ Deno already installed (v${DENO_VERSION})"
else
    print_loading "   ⬇️  Installing Deno"
    
    # Try system-wide installation first
    curl -fsSL https://deno.land/x/install/install.sh | DENO_INSTALL=/usr/local sh > /dev/null 2>&1
    
    # Check if installation succeeded
    if [ -f "/usr/local/bin/deno" ]; then
        chmod +x /usr/local/bin/deno 2>/dev/null
        echo "   ✅ Deno installed system-wide to /usr/local/bin/deno"
    else
        # Try alternative method for root
        curl -fsSL https://deno.land/install.sh | sh -s v1.x > /dev/null 2>&1
        if [ -f "/root/.deno/bin/deno" ]; then
            # Add to root's PATH
            echo 'export DENO_INSTALL="/root/.deno"' >> /root/.bashrc
            echo 'export PATH="$DENO_INSTALL/bin:$PATH"' >> /root/.bashrc
            echo 'export PATH="/root/.deno/bin:$PATH"' >> /root/.bashrc
            # Also add to current session
            export PATH="/root/.deno/bin:$PATH"
            echo "   ✅ Deno installed for root user"
        elif [ -n "$USER_HOME" ] && [ -f "$USER_HOME/.deno/bin/deno" ]; then
            echo "   ✅ Deno already installed for user $CURRENT_USER"
        else
            echo "   ⚠️  Deno installation attempted but not detected in standard locations."
            echo "      If you have Deno installed, it should work when running as regular user."
        fi
    fi
fi

# Ensure regular user has Deno in PATH
if [ -n "$USER_HOME" ] && [ "$CURRENT_USER" != "root" ]; then
    # Check if Deno is in user's shell config
    for rcfile in "$USER_HOME/.bashrc" "$USER_HOME/.zshrc"; do
        if [ -f "$rcfile" ]; then
            # Check if Deno path is already in the file
            if ! grep -q '.deno/bin' "$rcfile" 2>/dev/null; then
                # Add Deno to PATH
                echo 'export DENO_INSTALL="$HOME/.deno"' | sudo -u "$CURRENT_USER" tee -a "$rcfile" > /dev/null
                echo 'export PATH="$DENO_INSTALL/bin:$PATH"' | sudo -u "$CURRENT_USER" tee -a "$rcfile" > /dev/null
            fi
        fi
    done
fi

# STEP 4: Python venv for cookies
echo ""
echo "📦 STEP 4/5: Setting up Python environment for Chrome cookies..."
USER_DIR="/home/${CURRENT_USER:-$USER}/youtubedownloading"
ROOT_DIR="/root/youtubedownloading"

mkdir -p "$ROOT_DIR" 2>/dev/null
cd "$ROOT_DIR"
if [ -f "yt-venv/bin/activate" ]; then
    echo "   ✅ Root Python venv already exists"
else
    print_loading "   ⬇️  Creating root Python venv"
    python3 -m venv yt-venv > /dev/null 2>&1
    source yt-venv/bin/activate
    pip install -q secretstorage cryptography > /dev/null 2>&1
    deactivate
    echo "   ✅ Root Python venv setup complete"
fi

if [ "$CURRENT_USER" != "root" ] && [ "$CURRENT_USER" != "" ]; then
    mkdir -p "$USER_DIR" 2>/dev/null
    chown -R "$CURRENT_USER:$CURRENT_USER" "$USER_DIR" 2>/dev/null
    if sudo -u "$CURRENT_USER" test -f "$USER_DIR/yt-venv/bin/activate" 2>/dev/null; then
        echo "   ✅ User Python venv already exists"
    else
        print_loading "   ⬇️  Creating user Python venv"
        sudo -u "$CURRENT_USER" python3 -m venv "$USER_DIR/yt-venv" > /dev/null 2>&1
        sudo -u "$CURRENT_USER" bash -c "source $USER_DIR/yt-venv/bin/activate && pip install -q secretstorage cryptography > /dev/null 2>&1"
        echo "   ✅ User Python venv setup complete"
    fi
fi

# STEP 5: YutubuDownload script
echo ""
echo "📦 STEP 5/5: Installing YutubuDownload script..."
print_loading "   ⬇️  Fetching latest script"
curl -sL https://raw.githubusercontent.com/johnboscocjt/Youtube-Downloader-For-UbuntuTerminal/main/YutubuDownload -o /usr/local/bin/YutubuDownload > /dev/null 2>&1
chmod +x /usr/local/bin/YutubuDownload > /dev/null 2>&1

if command -v YutubuDownload &> /dev/null && YutubuDownload --version &> /dev/null; then
    echo "   ✅ YutubuDownload installed to /usr/local/bin/YutubuDownload"
    echo "   ✅ Version: $(YutubuDownload --version)"
else
    echo "   ❌ FAILED to install YutubuDownload. Try manually:"
    echo "      sudo curl -sL https://raw.githubusercontent.com/johnboscocjt/Youtube-Downloader-For-UbuntuTerminal/main/YutubuDownload -o /usr/local/bin/YutubuDownload"
    echo "      sudo chmod +x /usr/local/bin/YutubuDownload"
    exit 1
fi

# === COMPLETION MESSAGE ===
echo ""
echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                                                                              ║"
echo "║ ✅ INSTALLATION COMPLETE!                                                    ║"
echo "║                                                                              ║"
echo "║   Next steps:                                                                ║"
echo "║ 1. CLOSE ALL CHROME WINDOWS COMPLETELY (required for cookies)                ║"
echo "║ 2. Open terminal and run:                                                    ║"
echo "║    cd ~/youtubedownloading && YutubuDownload                                 ║"
echo "║ 3. Paste YouTube URL when prompted                                           ║"
echo "║                                                                              ║"
echo "║   💡 Tanzania Tip: Run during off-peak hours (after 10 PM EAT)               ║"
echo "║    for best success on unstable networks                                     ║"
echo "║                                                                              ║"
echo "║ 🌍 Made with ❤️ for Tanzania by Johnbosco (Dar es Salaam)                     ║"
echo "║                                                                              ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo ""

echo "YUTUBUDOWNLOAD v1.0 • TANZANIA'S TERMINAL POWER  "
echo "Fast • Reliable • Bot-Bypass • Designed for TZ Networks"
echo ""

echo "Version: YutubuDownload v1.0 (2026-02-08)"
echo "Repository: https://github.com/johnboscocjt/Youtube-Downloader-For-UbuntuTerminal"
echo ""

# Installation summary
echo "📊 Installation Summary:"
echo "   ✅ System dependencies: ffmpeg, python3-venv, python3-pip"
echo "   ✅ yt-dlp: $(yt-dlp --version 2>/dev/null || echo 'Not installed')"

# Deno status
if check_deno_installed; then
    DENO_VERSION=$(get_deno_version)
    echo "   ✅ Deno: v${DENO_VERSION} (installed)"
    if [ -f "/home/jbtechnix/.deno/bin/deno" ]; then
        echo "       Location: /home/jbtechnix/.deno/bin/deno"
        echo "       Note: Deno is installed for user 'jbtechnix'. When running YutubuDownload"
        echo "             as a regular user (not sudo), it will use your Deno installation."
    elif [ -f "/root/.deno/bin/deno" ]; then
        echo "       Location: /root/.deno/bin/deno"
    elif [ -f "/usr/local/bin/deno" ]; then
        echo "       Location: /usr/local/bin/deno (system-wide)"
    fi
else
    echo "   ⚠️  Deno: Not detected in standard locations"
    echo "       You have Deno installed as user 'jbtechnix'. To use it:"
    echo "       1. Run YutubuDownload as regular user (without sudo)"
    echo "       2. Or install Deno system-wide: sudo curl -fsSL https://deno.land/x/install/install.sh | sudo DENO_INSTALL=/usr/local sh"
fi

echo "   ✅ YutubuDownload: Installed to /usr/local/bin/YutubuDownload"
echo ""
echo "💡 IMPORTANT: Since Deno is installed as user 'jbtechnix', run YutubuDownload without sudo:"
echo "   cd ~/youtubedownloading && YutubuDownload"
echo ""
