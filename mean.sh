# This script installs the MEAN development stack on anay mac computer
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
if ask "Do you want to install yo?"; then
  if [ -e "/usr/local/bin/yo" ]
  then
  	echo "You already have yo installed!"
  else
    sudo npm install -g yo
  fi
fi
echo "Done!"
