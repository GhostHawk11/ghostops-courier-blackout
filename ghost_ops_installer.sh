#!/bin/bash
echo "[+] Installing Ghost_Ops system utilities..."

# Verify prerequisites
echo "[*] Checking for Bash, UFW, and sudo..."
command -v bash >/dev/null || { echo "[-] Bash not found. Aborting."; exit 1; }
command -v ufw >/dev/null || { echo "[-] UFW not installed. Aborting."; exit 1; }
command -v sudo >/dev/null || { echo "[-] Sudo unavailable. Aborting."; exit 1; }

# Copy operational script to system path
echo "[*] Deploying ghost_ops.sh to /usr/local/bin..."
sudo cp ghost_ops.sh /usr/local/bin/ghost_ops
sudo chmod +x /usr/local/bin/ghost_ops

# Create global alias (optional)
echo "alias ghost_ops='/usr/local/bin/ghost_ops'" >> ~/.bashrc
source ~/.baschmod +x ghostops_installer.shhrc

# Verify target assets
echo "[*] Validating support files in /home/amnesia/Persistent..."
for f in custom_torrc prefs.js vpn_config; do
  if [ ! -e "/home/amnesia/Persistent/$f" ]; then
    echo "[!] Warning: Missing $f. Ghost_Ops will still install, but browser/VPN configs may not apply."
  fi
done

echo "[✓] Ghost_Ops install complete. You can now run: ghost_ops"
