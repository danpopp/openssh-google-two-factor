#============================================================================
#Fedora 20:
#============================================================================
sudo yum install google-authenticator
sudo sed -i '/ChallengeResponseAuthentication/d' /etc/ssh/sshd_config
sudo echo 'ChallengeResponseAuthentication yes' >> /etc/ssh/sshd_config
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
sudo service sshd restart
