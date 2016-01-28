# This script installs the MEAN development stack on anay mac computer
echo 'DISCLAIMER: USE THIS SCRIPT AT YOUR OWN RISK!'
echo 'THE AUTHOR TAKES NO RESPONSIBILITY FOR THE RESULTS OF THIS SCRIPT.'
echo "Welcome the the MEAN Installer script for Macs"
echo "Please make sure that you do not have node installed from another source such as the pkg"
echo "This script uses homebrew and may install it if necessary"
echo "This script cannot be run with sudo as it will create brew errors"
echo 'Press Control-C to quit now.'
read

ask() {
    # http://djm.me/ask
    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        # Ask the question - use /dev/tty in case stdin is redirected from somewhere else
        read -p "$1 [$prompt] " REPLY </dev/tty

        # Default?
        if [ -z "$REPLY" ]; then
            REPLY=$default
        fi

        # Check if the reply is valid
        case "$REPLY" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

if [ -e "/usr/local/bin/brew" ]
then
	echo "Homebrew found!"
else
  echo "Homebrew not found"
  echo "Installing homebrew..."
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  brew doctor
fi
if [ -e "/usr/local/bin/node" ]
then
	echo "Node found!"
else
  echo "Node not found"
  echo "Installing Node..."
	sudo chown -R $USER /usr/local/share/systemtap/tapset
	brew install node
fi
if [ -e "/usr/local/bin/mongod" ]
then
	echo "Mongodb found!"
else
  echo "Mongodb not found"
  echo "Installing Mongodb..."
  brew install mongodb
fi
if [ -d "/data/db" ]; then
  echo "Found Mongodb data dir"
else
  done=false
  if ask "Do you want to create a mongodb data dir?"; then
    while [ $done = false ]
    do
      echo "Enter a location (/data/db):"
      read dir
      if [ -d "$dir" ]; then
        echo "$dir already exists!"
      else
        if [ $dir == "/data/db" ]; then
          echo "Creating database directory..."
          sudo mkdir -p /data/db
          sudo chown -R $USER /data/db
          done=true
        else
          echo "To start mongodb you must use mongod --dbpath $dir"
          if ask "Are you ok with this?"; then
            echo "Ok, remember this..."
            echo "Creating database directory..."
            sudo mkdir -p $dir
            sudo chown -R $USER $dir
            done=true
          fi
        fi
      fi
    done
  fi
fi
if [ -e "/usr/local/bin/grunt" ]
then
	echo "Grunt found!"
else
  echo "Grunt not found"
  echo "Installing Grunt-cli..."
  sudo npm install -g grunt-cli
fi
echo "Updating npm repos"
sudo npm update
echo "Node: "
node --version
echo "NPM: "
npm --version
if ask "Do you want to update npm and node?"; then
    echo "Yes"
    echo "Updating npm and node"
    echo "Updating brew repos"
    brew update
    echo "Upgrading node"
    brew upgrade node
    echo "Upgrading npm"
    sudo npm install -g npm
else
    echo "Not updating node and npm"
fi
if [ -e "/usr/local/bin/yo" ]
then
	echo "Yo found!"
else
  if ask "Do you want to install yo?"; then
    sudo npm install -g yo
  fi
fi
echo "Done!"
