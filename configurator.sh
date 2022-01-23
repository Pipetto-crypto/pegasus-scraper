read -p "Do you want to modify your config file to add new systems(y/n):" prompt
if test $prompt == "y";
then 
	nano $HOME/.skyscraper/config.ini
	read -p "Do you want to scrape your systems(y/n)?:" prompt2
	if test $prompt2 == "y";
	then 
		echo -e "\nStarting scraping, answer when prompted"
        	read -p "Select platforms to scrap games for(separate them with spaces):" plats
        	read -p "Select a scraper module to use, screenscraper highly suggested:"  scrap
        	for i in $plats
                do
                        skyscraper -p $i -s $scrap
                done
	fi
else
	read -p "Do you want to scrape your systems(y/n):" prompt3
	if test $prompt3 == "y";
	then
		echo -e "\nStarting scraping, answer questions when prompted"
		read -p "Select platforms to scrap games for(separate them with spaces):" plats
		read -p "Select scraper to use, screenscraper highly suggested:"  scrap
		for i in $plats
		do
			skyscraper -p $i -s $scrap	
		done	
	fi
fi

read -p "Do you want to insert launch commands for your emualtors?(y/n)" prompt4
if test $prompt4 == "y";
then
	echo -e "\nInserting launch commands, you may refer to them on the github page according to the emulator you want to use.You can paste them below shortname line. Once you are done ctrl+o to save, ctrl+x to exit"; sleep 15
	grep -o '"/.*"' $HOME/.skyscraper/config.ini | sed 's/"//g' > temp.txt
	for f in $(cat temp.txt)
	do
		if grep -oq 'launch:' $f/metadata.pegasus.txt;
		then 
			echo -e "\nLaunch command already present, skipping"; sleep 3
		else
			nano $f/metadata.pegasus.txt
		fi
done
fi

read -p "Do you want me to configure Pegasus for you?(y/n)" prompt5
if test $prompt5 == "y";
then
	mkdir -p /sdcard/pegasus-frontend
	rm -rf /sdcard/pegasus-frontend/game_dirs.txt
	touch /sdcard/pegasus-frontend/game_dirs.txt
	grep -o '"/.*"' $HOME/.skyscraper/config.ini | sed 's/"//g' > temp.txt
	for f in $(cat temp.txt)
	do
		echo "$f" >> /sdcard/pegasus-frontend/game_dirs.txt
	done
fi

echo -e "\nDone"

rm -rf temp.txt
