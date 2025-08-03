#!/bin/bash
echo "[+] Ghost_Ops Lockdown Installer"

### CONFIG ###
SCRIPT_PATH="./ghost_ops.sh"
INSTALL_PATH="/usr/local/bin/ghost_ops"
MONERO_HASH_URL="https://web.getmonero.org/downloads/hashes.txt"
MONERO_BIN="/usr/bin/monero-wallet-cli"
EXPIRY_DAYS=7

### FUNCTIONS ###

# Check for required binaries
function verify_dependencies {
  echo "[*] Verifying system dependencies..."
  for cmd in bash sudo ufw curl sha256sum; do
    command -v $cmd >/dev/null || { echo "[-] Missing $cmd"; exit 1; }
  done
}

# Validate presence of Ghost_Ops script
function verify_script {
  if [ ! -f "$SCRIPT_PATH" ]; then
    echo "[-] Ghost_Ops script not found at $SCRIPT_PATH"
    exit 1
  fi
}

# Monero hash verification
function verify_monero {
  echo "[*] Verifying Monero binary integrity..."
  curl -s "$MONERO_HASH_URL" -o hashes.txt
  grep "$(basename $MONERO_BIN)" hashes.txt | sha256sum -c --status
  if [ $? -ne 0 ]; then
    echo "[!] Monero hash mismatch. Proceed with caution."
  else
    echo "[+] Monero binary validated."
  fi
}

# Setup expiry logic
function set_expiry {
  echo "[*] Embedding expiry logic..."
  install_date=$(date +%s)
  expiry_date=$((install_date + EXPIRY_DAYS * 86400))
  echo $expiry_date > ~/.ghost_ops_expiry
}

# Expiry check
function check_expiry {
  now=$(date +%s)
  expiry_date=$(cat ~/.ghost_ops_expiry 2>/dev/null || echo 0)
  if [ "$now" -gt "$expiry_date" ]; then
    echo "[!] Ghost_Ops expired. Self-wiping..."
    rm -f "$INSTALL_PATH" ~/.ghost_ops_expiry
    exit 2
  fi
}

# Deploy script
function deploy_script {
  echo "[*] Installing ghost_ops.sh to $INSTALL_PATH..."
  sudo cp "$SCRIPT_PATH" "$INSTALL_PATH"
  sudo chmod +x "$INSTALL_PATH"
  echo "alias ghost_ops='$INSTALL_PATH'" >> ~/.bashrc
  source ~/.bashrc
}

# Verify config assets
function verify_assets {
  echo "[*] Checking Persistent folder assets..."
  for item in custom_torrc prefs.js vpn_config; do
    if [ ! -e "/home/amnesia/Persistent/$item" ]; then
      echo "[!] Missing /home/amnesia/Persistent/$item"
    fi
  done
}

### EXECUTION ###
verify_dependencies
verify_script
verify_monero
deploy_script
verify_assets
set_expiry
check_expiry

echo "[✓] Ghost_Ops hardened install complete. Run 'ghost_ops' to launch."
