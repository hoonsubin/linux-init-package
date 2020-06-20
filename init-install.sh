#download list after a new Linux install (for ubuntu)

sudo apt update && sudo apt upgrade -y;
sudo add-apt-repository universe;
sudo apt install git curl libreoffice net-tools build-essential libssl-dev libffi-dev chrome-gnome-shell gnome-tweak-tool;
sudo apt install python3 python3-pip python3-dev python3-tk python3-setuptools python3-matplotlib python3-numpy python3-scipy;
sudo apt install default-jdk default-jre wireshark gitg;

# install dev tools from snap
sudo snap install dotnet-sdk --classic;
sudo snap install chromium;
sudo snap install pycharm-community --classic;
sudo snap install postman;
sudo snap install code --classic;
sudo snap install dotnet-sdk --classic;

# install yarn
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add -;
echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list;
sudo apt update && sudo apt install yarn;

# install rust and substrate tools
curl https://getsubstrate.io -sSf | bash -s --;
source ~/.cargo/env;

# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash;
# This loads nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")";
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh";

nvm install node;

