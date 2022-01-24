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
			skyscraper -p $i
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
			skyscraper -p $i	
		done	
	fi
fi

read -p "Do you want to insert launch commands for your emualtors?(y/n)" prompt4
if test $prompt4 == "y";
then
	grep -o '"/.*"' $HOME/.skyscraper/config.ini | sed 's/"//g' > temp.txt
	for f in $(cat temp.txt)
	do
		if grep -oq 'launch:' $f/metadata.pegasus.txt;
		then 
			echo -e "\nLaunch command already present, skipping"; sleep 3
		else
			if awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: ps2';
			then
				PS2='launch: am start\n -n xyz.aethersx2.android/.EmulationActivity\n -a android.intent.action.MAIN\n -e bootPath "{file.documenturi}"\n'
				sed -i "0,/^$/{s|^$|$PS2|}" $f/metadata.pegasus.txt
			fi
		fi
	done
fi

read -p "\nDo you want me to configure Pegasus for you?(y/n)" prompt5
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
