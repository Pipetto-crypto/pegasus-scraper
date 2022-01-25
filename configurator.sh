while true
do
read -p "Do you want to modify your config file to add new systems(y/n):" prompt
if test "$prompt" == "y";
then 
	nano $HOME/.skyscraper/config.ini
	break
elif test "$prompt" == "n";
then
	break
else
	echo -e "Invalid option, retry"
	continue
fi
done

while true
do
	read -p "Do you want to scrape your systems(y/n)?:" prompt2
	if test "$prompt2" == "y";
	then 
		echo -e "\nStarting scraping, answer when prompted"
        	read -p "Select platforms to scrap games for(separate them with spaces):" plats
        	read -p "Select a scraper module to use, screenscraper highly suggested:"  scrap
        	for i in $plats
        	do
        		skyscraper -p $i -s $scrap
			skyscraper -p $i
        	done
		break
	elif test "$prompt2" == "n";
	then
		break
	else
		echo -e "You selected an invalid option, go back"
		continue
	fi
done

while true
do
	read -p "Do you want to insert launch commands for your emualtors?(y/n)" prompt3
	if test "$prompt3" == "y";
	then
		grep -o '"/.*"' $HOME/.skyscraper/config.ini | sed 's/"//g' > temp.txt
		for f in $(cat temp.txt)
		do
			if grep -oq 'launch:' $f/metadata.pegasus.txt;
			then 
				echo -e "\nLaunch command already present, skipping"; sleep 3
			else
				if awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: ps2' > /dev/null;
				then
					echo -e "\nAdding AetherSX2 launch command"
					PS2='launch: am start\n -n xyz.aethersx2.android/.EmulationActivity\n -a android.intent.action.MAIN\n -e bootPath "{file.documenturi}"\n'
					sed -i "0,/^$/{s|^$|$PS2|}" $f/metadata.pegasus.txt
				else if awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: gc' > /dev/null;
				then
					echo -e "\nAdding Dolphin MMJR launch command"
					GC='launch: am start\n -n org.mm.jr/org.dolphinemu.dolphinemu.ui.main.MainActivity\n -a android.intent.action.VIEW\n --es AutoStartFile "{file.path}"\n'
					sed -i "0,/^$/{s|^$|$GC|}" $f/metadata.pegasus.txt			
				else if awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: wii' > /dev/null;
				then
					echo -e "\nAdding Dolphin MMJR launch command"
					WII='launch: am start\n -n org.mm.jr/org.dolphinemu.dolphinemu.ui.main.MainActivity\n -a android.intent.action.VIEW\n --es AutoStartFile "{file.path}"\n'
					sed -i "0,/^$/{s|^$|$WII|}" $f/metadata.pegasus.txt	sed -i "0,/^$/{s|^$|$GC|}" $f/metadata.pegasus.txt
				else if awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: psx' > /dev/null;
				then
					echo -e "\nAdding DuckStation launch command"
					PSX='launch: am start\n -n com.github.stenzek.duckstation/.EmulationActivity\n -a android.intent.action.VIEW\n -e bootPath "{file.path}"\n --ez resumeState 0\n'
					sed -i "0,/^$/{s|^$|$PSX|}" $f/metadata.pegasus.txt
				else if awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: n64' > /dev/null;
				then
					echo -e "\nAdding M64Plus Fz launch command"
					N64='launch: am start\n -n org.mupen64plusae.v3.fzurita/paulscode.android.mupen64plusae.SplashActivity\n -a android.intent.action.VIEW\n -d "{file.uri}"\n'
					sed -i "0,/^$/{s|^$|$N64|}" $f/metadata.pegasus.txt
				else if awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: n64' > /dev/null;
				then
					echo -e "\nAdding M64Plus Fz launch command"
					N64='launch: am start\n -n org.mupen64plusae.v3.fzurita/paulscode.android.mupen64plusae.SplashActivity\n -a android.intent.action.VIEW\n -d "{file.uri}"\n'
					sed -i "0,/^$/{s|^$|$N64|}" $f/metadata.pegasus.txt
				fi
			fi
		done
		break
	elif test "$prompt3" == "n";
	then
		 break
	else
		echo -e "Invalid option, retry"
		continue
	fi
done

while true 
do
	read -p "Do you want me to configure Pegasus for you?(y/n)" prompt4
	if test "$prompt4" == "y";
	then
		mkdir -p /sdcard/pegasus-frontend
		rm -rf /sdcard/pegasus-frontend/game_dirs.txt
		touch /sdcard/pegasus-frontend/game_dirs.txt
		grep -o '"/.*"' $HOME/.skyscraper/config.ini | sed 's/"//g' > temp.txt
		for f in $(cat temp.txt)
		do
			echo "$f" >> /sdcard/pegasus-frontend/game_dirs.txt
		done
		break
	elif test "$prompt4" == "n";
	then
		break
	else
	echo -e "Invalid option,retry"
	continue
fi
done

echo -e "\nDone"

rm -rf temp.txt

