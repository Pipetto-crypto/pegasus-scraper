# Pegasus-scraper

DISCLAIMER:

While you have the freedom to put your games wherever you want, in order for the script to be able to add launch commands properly you need to put games from different systems in different folders else you will have to add launch commands manually. 

Simple bash script that mainly scrapes games for you, eventually it can configure Pegasus to load your games folders but access to storage is broken in Android 11+ so that's not is intended purpose. To use:

Download termux from fdroid and paste the following commands:

termux-setup-storage,  answer yes when prompted.

curl -O -L https://github.com/Pipetto-crypto/pegasus-scraper/raw/master/installer.sh && source installer.sh

Type pegasus-config everytime you want to scrape new games.

# About The Scripts

The installer script will install the required dependencies and compile skyscraper. 

It will create a basic artwork file and config file for skyscraper to work. 

During the execution, you will be prompted to edit the config file with nano, it's highly suggested to use something with arrows keys(either a physical keyboard, Hacker Keyboard from PlayStore or a gamepad).

The configurator script will allow you to do the following tasks:

1. Edit the config file with nano to add new systems.

2. Scrape your games by selecting platforms and scraping modules:

For a list of supported platforms refer to this: https://github.com/muldjord/skyscraper/blob/master/docs/PLATFORMS.md

For a list of supported scraping modules refer to this: https://github.com/muldjord/skyscraper/blob/master/docs/SCRAPINGMODULES.md

3. Add a launch command to the metadata file, required for Pegasus to open your games with an emulator. 

If you have done what the disclaimer says then this operation will be able to add launch commands completely automatically. Else you can fall back to manual editing with nano. 

For a list of launch commands, you may refer to this: https://pegasus-frontend.org/tools/metagen-android/

4. Configure Pegasus to be able to launch your games
