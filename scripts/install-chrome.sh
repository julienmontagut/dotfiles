# Import the signing key into a dedicated keyring
wget -qO- https://dl.google.com/linux/linux_signing_key.pub |
    gpg --dearmor |
    sudo tee /usr/share/keyrings/google-chrome.gpg >/dev/null

# Add the repo with explicit signed-by (no global trust)
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" |
    sudo tee /etc/apt/sources.list.d/google-chrome.list

# Install
sudo apt update && sudo apt install google-chrome-stable
