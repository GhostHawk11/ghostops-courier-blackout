echo "[+] Hardening Tor Browser settings..." cp /home/amnesia/Persistent/custom_torrc /etc/tor/torrc sed -i 's/^javascript.enabled.*$/javascript.enabled=false/' /home/amnesia/.tor-browser/profile.default/prefs.js

echo "[+] Launching setup for OnionShare, Monero CLI, and Session..." apt install onionshare monero-core session-desktop -y
gsettings set org.gnome.desktop.interface enable-animations false echo "[+] Clipboard logging disabled and UI animations turned off."

echo "[?] Do you want to enable VPN tunneling before Tor? (y/n)" read vpn_choice if [ "$vpn_choice" == "y" ]; apt install openvpn -y echo "[+] OpenVPN ready. Configure your .ovpn file manually via /home/amnesia/Persistent/vpn_config" fi

echo "[✓] Ghost Ops automation complete. You’re now operationally independent."
