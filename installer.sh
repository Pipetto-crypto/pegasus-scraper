#!/data/data/com.termux/files/usr/bin/bash

while true
do
	read -p "Before I start, do you want me to fetch Pegasus for you?(y/n):" instpmt
	if test "$instpmt" == "y";
		then
		curl -o pegasus.apk -L https://github.com/mmatyas/pegasus-frontend/releases/download/continuous/pegasus-fe_alpha16-8-g438d0f25_android.apk
		mv pegasus.apk /storage/emulated/0
		while true
		do
			read -p "Pegasus apk has been moved to the root of your internal storage, install it then press enter to continue" instscc 
			if test "$instscc" == "";
			then
				break
			else
				echo -e "Invalid option,retry"
				continue
			fi
		done	
		break
	elif test "$instpmt" == "n";
	then
		break
	else
		echo -e "Invalid option, retry"
		continue
	fi
done


echo -e "\n"
echo -e "Updating, upgrading packages and install x11-repo"; sleep 2
echo -e "\n"
pkg update -y 
pkg install x11-repo -y
echo -e "\nInstalling dependencies"; sleep 2
echo -e "\n"
pkg install git qt5-qtbase build-essential wget -y 
if test ! -f $PATH/skyscraper;
then   
	echo -e "\nCloning, compiling and installing Skyscraper"; sleep 2
	echo -e "\n"
    git clone https://github.com/muldjord/skyscraper.git
    cd skyscraper
    qmake
    make
    mv Skyscraper $PATH/skyscraper
	echo -e "\nInstalled, returning back to home folder"; sleep 2
	cd ..
else
	echo -e "\nSkyscraper already installed, skipping"; sleep 2
fi 

mkdir -p .skyscraper
if test ! -f $HOME/.skyscraper/artwork.xml;
then
	echo -e "\nCreating artwork.xml"; sleep 2
	echo -e "\n"
	wget https://raw.githubusercontent.com/muldjord/skyscraper/master/artwork.xml
	mv artwork.xml $HOME/.skyscraper 
else
	echo -e "\nartwork.xml already present, skipping"; sleep 2
fi


if test ! -f $HOME/.skyscraper/config.ini;
then
	echo -e "\nCreating config file"; sleep 2
	echo -e "\n"
	wget -L https://raw.githubusercontent.com/Pipetto-crypto/pegasus-scraper/master/config.ini
	echo -e "\nOpening the config file: insert game paths and add screenscraper account (optional).\nPress ctrl+o when done and ctrl+x to edit"; sleep 10
	nano config.ini
	mv config.ini $HOME/.skyscraper
else
	echo -e "\nconfig.ini already present, skipping"; sleep 2
fi

echo -e "\nFetching scraper script and cleaning"
rm -rf skyscraper
rm -rf installer.sh
rm -rf /sdcard/pegasus.apk
pkg clean && pkg autoclean
rm -rf configurator.sh
echo -e "\n"
wget -L https://raw.githubusercontent.com/Pipetto-crypto/pegasus-scraper/master/configurator.sh
chmod a+x configurator.sh
mv configurator.sh $PATH/pegasus-config


