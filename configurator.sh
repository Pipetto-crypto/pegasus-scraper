function hasRetroArch64(){
if test -d /storage/emulated/0/Android/data/com.retroarch.aarch64;
then
	return 0
else
	return 1
fi
}

function hasRetroArch32(){
if test -d /storage/emulated/0/Android/data/com.retroarch;
then
	return 0
else
	return 1
fi
}

while true
do
read -p "Do you want to modify your config file to add new systems(y/n)?:" prompt
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
        		skyscraper -p $i -s $scrap --addext '*.chd'
			skyscraper -p $i --addext '*.chd'
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
	read -p "Do you want to add launch commands manually(Read the DISCLAIMER)(y/n)?:" pmtman
	if test "$pmtman" == "y";
	then
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
		break
	elif test "$pmtman" == "n";
	then
		break
	else
		echo -e "Invalid option, retry"
	fi
done


while true
do
	read -p "Do you want to insert launch commands for your emulators(y/n)?:" prompt3
	if test "$prompt3" == "y";
	then
		grep -o '"/.*"' $HOME/.skyscraper/config.ini | sed 's/"//g' > temp.txt
		for f in $(cat temp.txt)
		do
			if grep -oq 'launch:' $f/metadata.pegasus.txt;
			then 
				echo -e "\nLaunch command already present, skipping"; sleep 3
			else
				if awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: ps2' > /dev/null 2>&1;
				then
					echo -e "\nAdding AetherSX2 launch command"; sleep 3
					PS2='launch: am start\n -n xyz.aethersx2.android/.EmulationActivity\n -a android.intent.action.MAIN\n -e bootPath "{file.documenturi}"\n'
					sed -i "0,/^$/{s|^$|$PS2|}" $f/metadata.pegasus.txt > /dev/null 2>&1
				elif awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: gc' > /dev/null 2>&1;
				then
					echo -e "\nAdding Dolphin MMJR launch command"; sleep 3
					GC='launch: am start\n -n org.mm.jr/org.dolphinemu.dolphinemu.ui.main.MainActivity\n -a android.intent.action.VIEW\n --es AutoStartFile "{file.path}"\n'
					sed -i "0,/^$/{s|^$|$GC|}" $f/metadata.pegasus.txt > /dev/null	2>&1		
				elif awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: wii' > /dev/null 2>&1;
				then
					echo -e "\nAdding Dolphin MMJR launch command"; sleep 3
					WII='launch: am start\n -n org.mm.jr/org.dolphinemu.dolphinemu.ui.main.MainActivity\n -a android.intent.action.VIEW\n --es AutoStartFile "{file.path}"\n'
					sed -i "0,/^$/{s|^$|$WII|}" $f/metadata.pegasus.txt > /dev/null	2>&1
				elif awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: psx' > /dev/null 2>&1;
				then
					echo -e "\nAdding DuckStation launch command"; sleep 3
					PSX='launch: am start\n -n com.github.stenzek.duckstation/.EmulationActivity\n -a android.intent.action.VIEW\n -e bootPath "{file.path}"\n --ez resumeState 0\n'
					sed -i "0,/^$/{s|^$|$PSX|}" $f/metadata.pegasus.txt > /dev/null 2>&1
				elif awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: n64' > /dev/null 2>&1;
				then
					echo -e "\nAdding M64PlusFZ launch command"; sleep 3
					N64='launch: am start\n -n org.mupen64plusae.v3.fzurita/paulscode.android.mupen64plusae.SplashActivity\n -a android.intent.action.VIEW\n -d "{file.uri}"\n'
					sed -i "0,/^$/{s|^$|$N64|}" $f/metadata.pegasus.txt > /dev/null 2>&1
				elif awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: nes' > /dev/null 2&>1;
				then
					echo -e "\nAdding Nestopia Retroarch core launch command"; sleep 3
					if hasRetroArch64;
					then
						NES='launch: am start\n -n com.retroarch.aarch64/com.retroarch.browser.retroactivity.RetroActivityFuture\n -e ROM {file.path}\n -e LIBRETRO /data/data/com.retroarch.aarch64/cores/nestopia_libretro_android.so\n -e CONFIGFILE /storage/emulated/0/Android/data/com.retroarch.aarch64/files/retroarch.cfg\n -e IME com.android.inputmethod.latin/.LatinIME\n -e DATADIR /data/data/com.retroarch.aarch64\n -e APK /data/app/com.retroarch.aarch64-1/base.apk\n -e SDCARD /storage/emulated/0\n -e EXTERNAL /storage/emulated/0/Android/data/com.retroarch.aarch64/files\n --activity-clear-task\n --activity-clear-top\n --activity-no-history\n'
						sed -i "0,/^$/{s|^$|$NES|}" $f/metadata.pegasus.txt > /dev/null 2>&1
					elif hasRetroArch32;
					then
						NES='launch: am start\n -n com.retroarch/.browser.retroactivity.RetroActivityFuture\n -e ROM {file.path}\n -e LIBRETRO /data/data/com.retroarch/cores/nestopia_libretro_android.so\n -e CONFIGFILE /storage/emulated/0/Android/data/com.retroarch/files/retroarch.cfg\n -e IME com.android.inputmethod.latin/.LatinIME\n -e DATADIR /data/data/com.retroarch\n -e APK /data/app/com.retroarch-1/base.apk\n -e SDCARD /storage/emulated/0\n -e EXTERNAL /storage/emulated/0/Android/data/com.retroarch/files\n --activity-clear-task\n --activity-clear-top\n --activity-no-history\n'
						sed -i "0,/^$/{s|^$|$NES|}" $f/metadata.pegasus.txt > /dev/null	2>&1		
					else
						echo -e "Retroarch not installed, skipping"; sleep 3
					fi
				elif awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: snes' > /dev/null 2>&1;
				then
					echo -e "\nAdding bsnes Retroarch core launch command"; sleep 3
					if hasRetroArch64;
					then
						SNES='launch: am start\n -n com.retroarch.aarch64/com.retroarch.browser.retroactivity.RetroActivityFuture\n -e ROM {file.path}\n -e LIBRETRO /data/data/com.retroarch.aarch64/cores/bsnes_libretro_android.so\n -e CONFIGFILE /storage/emulated/0/Android/data/com.retroarch.aarch64/files/retroarch.cfg\n -e IME com.android.inputmethod.latin/.LatinIME\n -e DATADIR /data/data/com.retroarch.aarch64\n -e APK /data/app/com.retroarch.aarch64-1/base.apk\n -e SDCARD /storage/emulated/0\n -e EXTERNAL /storage/emulated/0/Android/data/com.retroarch.aarch64/files\n --activity-clear-task\n --activity-clear-top\n --activity-no-history\n'
						sed -i "0,/^$/{s|^$|$SNES|}" $f/metadata.pegasus.txt > /dev/null 2>&1
					elif hasRetroArch32;
					then

						SNES='launch: am start\n -n com.retroarch/.browser.retroactivity.RetroActivityFuture\n -e ROM {file.path}\n -e LIBRETRO /data/data/com.retroarch/cores/bsnes_libretro_android.so\n -e CONFIGFILE /storage/emulated/0/Android/data/com.retroarch/files/retroarch.cfg\n -e IME com.android.inputmethod.latin/.LatinIME\n -e DATADIR /data/data/com.retroarch\n -e APK /data/app/com.retroarch-1/base.apk\n -e SDCARD /storage/emulated/0\n -e EXTERNAL /storage/emulated/0/Android/data/com.retroarch/files\n --activity-clear-task\n --activity-clear-top\n --activity-no-history\n'
						sed -i "0,/^$/{s|^$|$SNES|}" $f/metadata.pegasus.txt > /dev/null 2>&1		
					else
						echo -e "Retroarch not installed, skipping"; sleep 3
					fi
				elif awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: gbc' > /dev/null 2>&1;
				then
					echo -e "\nAdding gambatte Retroarch core launch command"; sleep 3
					if hasRetroArch64;
					then
						GBC='launch: am start\n -n com.retroarch.aarch64/com.retroarch.browser.retroactivity.RetroActivityFuture\n -e ROM {file.path}\n -e LIBRETRO /data/data/com.retroarch.aarch64/cores/gambatte_libretro_android.so\n -e CONFIGFILE /storage/emulated/0/Android/data/com.retroarch.aarch64/files/retroarch.cfg\n -e IME com.android.inputmethod.latin/.LatinIME\n -e DATADIR /data/data/com.retroarch.aarch64\n -e APK /data/app/com.retroarch.aarch64-1/base.apk\n -e SDCARD /storage/emulated/0\n -e EXTERNAL /storage/emulated/0/Android/data/com.retroarch.aarch64/files\n --activity-clear-task\n --activity-clear-top\n --activity-no-history\n'
						sed -i "0,/^$/{s|^$|$GBC|}" $f/metadata.pegasus.txt > /dev/null 2>&1
					elif hasRetroArch32;
					then
						GBC='launch: am start\n -n com.retroarch/.browser.retroactivity.RetroActivityFuture\n -e ROM {file.path}\n -e LIBRETRO /data/data/com.retroarch/cores/gambatte_libretro_android.so\n -e CONFIGFILE /storage/emulated/0/Android/data/com.retroarch/files/retroarch.cfg\n -e IME com.android.inputmethod.latin/.LatinIME\n -e DATADIR /data/data/com.retroarch\n -e APK /data/app/com.retroarch-1/base.apk\n -e SDCARD /storage/emulated/0\n -e EXTERNAL /storage/emulated/0/Android/data/com.retroarch/files\n --activity-clear-task\n --activity-clear-top\n --activity-no-history\n'
						sed -i "0,/^$/{s|^$|$GBC|}" $f/metadata.pegasus.txt > /dev/null	2>&1			
					else
						echo -e "Retroarch not installed, skipping"; sleep 3
					fi
				elif awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: gb' > /dev/null 2>&1;
				then
					echo -e "\nAdding gambatte Retroarch core launch command"; sleep 3
					if hasRetroArch64;
					then
						GB='launch: am start\n -n com.retroarch.aarch64/com.retroarch.browser.retroactivity.RetroActivityFuture\n -e ROM {file.path}\n -e LIBRETRO /data/data/com.retroarch.aarch64/cores/gambatte_libretro_android.so\n -e CONFIGFILE /storage/emulated/0/Android/data/com.retroarch.aarch64/files/retroarch.cfg\n -e IME com.android.inputmethod.latin/.LatinIME\n -e DATADIR /data/data/com.retroarch.aarch64\n -e APK /data/app/com.retroarch.aarch64-1/base.apk\n -e SDCARD /storage/emulated/0\n -e EXTERNAL /storage/emulated/0/Android/data/com.retroarch.aarch64/files\n --activity-clear-task\n --activity-clear-top\n --activity-no-history\n'
						sed -i "0,/^$/{s|^$|$GB|}" $f/metadata.pegasus.txt > /dev/null 2>&1
					elif hasRetroArch32;
					then
						GB='launch: am start\n -n com.retroarch/.browser.retroactivity.RetroActivityFuture\n -e ROM {file.path}\n -e LIBRETRO /data/data/com.retroarch/cores/gambatte_libretro_android.so\n -e CONFIGFILE /storage/emulated/0/Android/data/com.retroarch/files/retroarch.cfg\n -e IME com.android.inputmethod.latin/.LatinIME\n -e DATADIR /data/data/com.retroarch\n -e APK /data/app/com.retroarch-1/base.apk\n -e SDCARD /storage/emulated/0\n -e EXTERNAL /storage/emulated/0/Android/data/com.retroarch/files\n --activity-clear-task\n --activity-clear-top\n --activity-no-history\n'
						sed -i "0,/^$/{s|^$|$GB|}" $f/metadata.pegasus.txt > /dev/null	2>&1
					else
						echo -e "Retroarch not installed, skipping"; sleep 3
					fi
				elif awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: gba' > /dev/null 2>&1;
				then
					echo -e "\nAdding mgba Retroarch core launch command"; sleep 3
					if hasRetroArch64;
					then
						GBA='launch: am start\n -n com.retroarch.aarch64/com.retroarch.browser.retroactivity.RetroActivityFuture\n -e ROM {file.path}\n -e LIBRETRO /data/data/com.retroarch.aarch64/cores/mgba_libretro_android.so\n -e CONFIGFILE /storage/emulated/0/Android/data/com.retroarch.aarch64/files/retroarch.cfg\n -e IME com.android.inputmethod.latin/.LatinIME\n -e DATADIR /data/data/com.retroarch.aarch64\n -e APK /data/app/com.retroarch.aarch64-1/base.apk\n -e SDCARD /storage/emulated/0\n -e EXTERNAL /storage/emulated/0/Android/data/com.retroarch.aarch64/files\n --activity-clear-task\n --activity-clear-top\n --activity-no-history\n'
						sed -i "0,/^$/{s|^$|$GBA|}" $f/metadata.pegasus.txt > /dev/null 2>&1
					elif hasRetroArch32;
					then
						GBA='launch: am start\n -n com.retroarch/.browser.retroactivity.RetroActivityFuture\n -e ROM {file.path}\n -e LIBRETRO /data/data/com.retroarch/cores/mgba_libretro_android.so\n -e CONFIGFILE /storage/emulated/0/Android/data/com.retroarch/files/retroarch.cfg\n -e IME com.android.inputmethod.latin/.LatinIME\n -e DATADIR /data/data/com.retroarch\n -e APK /data/app/com.retroarch-1/base.apk\n -e SDCARD /storage/emulated/0\n -e EXTERNAL /storage/emulated/0/Android/data/com.retroarch/files\n --activity-clear-task\n --activity-clear-top\n --activity-no-history\n'
						sed -i "0,/^$/{s|^$|$GBA|}" $f/metadata.pegasus.txt > /dev/null	2>&1
					else
						echo -e "Retroarch not installed, skipping"; sleep 3		
					fi
				elif awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: psp' > /dev/null 2>&1;
				then
					while true 
					do
						echo -e "\n"
						read -p "About to add PPSSPP RetroArch core. Do you want me to fall back to PPSSPP standalone app(only works with PPSSPP v1.11.3 and below)(y/n)?:" psppmt
						if test "$psppmt" == "y";
						then
							echo -e "\nAdding PPSSPP launch command"; sleep 3
							PSP='launch: am start\n -n org.ppsspp.ppsspp/.PpssppActivity\n -a android.intent.action.VIEW\n -d "{file.path}"\n'
							sed -i "0,/^$/{s|^$|$PSP|}" $f/metadata.pegasus.txt > /dev/null 2>&1
							break
						elif test "$psppmt" == "n";
						then
							echo -e "\nAdding PPSSPP Retroarch core launch command"; sleep 3
							if hasRetroArch64;
							then
								PSP='launch: am start\n -n com.retroarch.aarch64/com.retroarch.browser.retroactivity.RetroActivityFuture\n -e ROM {file.path}\n -e LIBRETRO /data/data/com.retroarch.aarch64/cores/ppsspp_libretro_android.so\n -e CONFIGFILE /storage/emulated/0/Android/data/com.retroarch.aarch64/files/retroarch.cfg\n -e IME com.android.inputmethod.latin/.LatinIME\n -e DATADIR /data/data/com.retroarch.aarch64\n -e APK /data/app/com.retroarch.aarch64-1/base.apk\n -e SDCARD /storage/emulated/0\n -e EXTERNAL /storage/emulated/0/Android/data/com.retroarch.aarch64/files\n --activity-clear-task\n --activity-clear-top\n --activity-no-history\n'
								sed -i "0,/^$/{s|^$|$PSP|}" $f/metadata.pegasus.txt > /dev/null 2>&1
								break
							elif hasRetroArch32;
							then
								PSP='launch: am start\n -n com.retroarch/.browser.retroactivity.RetroActivityFuture\n -e ROM {file.path}\n -e LIBRETRO /data/data/com.retroarch/cores/ppsspp_libretro_android.so\n -e CONFIGFILE /storage/emulated/0/Android/data/com.retroarch/files/retroarch.cfg\n -e IME com.android.inputmethod.latin/.LatinIME\n -e DATADIR /data/data/com.retroarch\n -e APK /data/app/com.retroarch-1/base.apk\n -e SDCARD /storage/emulated/0\n -e EXTERNAL /storage/emulated/0/Android/data/com.retroarch/files\n --activity-clear-task\n --activity-clear-top\n --activity-no-history\n'
								sed -i "0,/^$/{s|^$|$PSP|}" $f/metadata.pegasus.txt > /dev/null 2>&1
								break
							else
								echo -e "Retroarch not installed,skipping"; sleep 3		
								break
							fi
						else
							echo -e "Invalid option, retry"
						fi
					done		

				elif awk 'NR==2' $f/metadata.pegasus.txt|grep 'shortname: nds' > /dev/null 2>&1;
				then
					echo -e "\nAdding Drastic launch command"; sleep 3
					NDS='launch: am start\n -n com.dsemu.drastic/.DraSticActivity\n -a android.intent.action.VIEW\n -d "{file.path}"\n'
					sed -i "0,/^$/{s|^$|$NDS|}" $f/metadata.pegasus.txt > /dev/null 2>&1
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
	echo -e "\n"
	read -p "Do you want me to configure Pegasus for you(y/n)?:" prompt4
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

