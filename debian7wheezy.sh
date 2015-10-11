#============================================================================
#Debian Wheezy: (AKA compile 2FA from source) [also tested for Kali 1.x/Moto]
#============================================================================
sudo apt-get update
sudo apt-get install build-essential libpam0g-dev libqrencode3 zlib1g-dev zlib1g libssl-dev debhelper dh-autoreconf openssh-server unzip
wget http://openbsd.mirror.frontiernet.net/pub/OpenBSD/OpenSSH/portable/openssh-6.8p1.tar.gz
tar -xvf openssh-6.8p1.tar.gz
cd openssh-6.8p1
./configure --with-pam
make
sudo make install
cd ..
wget https://github.com/google/google-authenticator/archive/master.zip
unzip master.zip
cd google-authenticator-master/libpam
./bootstrap.sh
./configure
make
sudo make install
cd ../..
sudo rm -rf master.zip google-authenticator-master openssh-6.8p1*
sudo cp /usr/local/lib/security/pam_google_authenticator.* /lib/x86_64-linux-gnu/security/
sudo sed -i 's/\/usr\/sbin/\/usr\/local\/sbin/g' /etc/init.d/ssh
#sudo apt-get install libpam-google-authenticator
sudo sed -i '/ChallengeResponseAuthentication/d' /usr/local/etc/sshd_config
sudo echo 'ChallengeResponseAuthentication yes' >> /usr/local/etc/sshd_config
sudo sed -i '/UsePAM/d' /usr/local/etc/sshd_config
sudo echo 'UsePAM yes' >> /usr/local/etc/sshd_config
sudo echo 'auth required pam_google_authenticator.so nullok' >> /etc/pam.d/sshd 
sudo echo '
if [ ! -e $HOME/.google_authenticator ]; then
  echo "it is recommended you setup two-step authentication to this server."
  read -n1 -p "Would you like to configure Google Authenticator now? (y/n) "
  echo
  if [[ "$REPLY" = [yY] ]]; then
    echo "Please ensure google-authenticator is installed before continuing."
    echo "It is available from your vendors marketplace / app store."
    echo -e $magenta
    read -p "Press ENTER to continue"
    google-authenticator
  fi
fi' >> /etc/profile
sudo /etc/init.d/ssh restart
