# Pegasus-scraper

Simple bash script that mainly scrapes games for you, eventually it can configure Pegasus to load your games folders but access to storage is broken in Android 11+ so that's not is intended purpose. To use:

Download termux from fdroid and paste the following commands:

termux-setup-storage,  answer yes when prompted.

curl -O -L https://github.com/Pipetto-crypto/pegasus-scraper/raw/master/installer.sh && source installer.sh

Paste bash configurator.sh everytime you want to scrape new games.

# About The Scripts

The installer script will install the required dependencies and compile skyscraper. 

It will create a basic artwork file and config file for skyscraper to work. 

During the execution, you will be prompted to edit the config file with nano, it's highly suggested to use something with arrows keys(either a physical keyboard, Hacker Keyboard from PlayStore or a gamepad). This is because I can't predict where you are going to put your games and I don't want you to be forced to put them in specific folders. 

The configurator script will allow you to do the following tasks:

1. Edit the config file with nano to add new systems.

2. Scrape your games by selecting platforms and scraping modules:

For a list of supported platforms refer to this: https://github.com/muldjord/skyscraper/blob/master/docs/PLATFORMS.md

For a list of supported scraping modules refer to this: https://github.com/muldjord/skyscraper/blob/master/docs/SCRAPINGMODULES.md

3. Add a launch command to the metadata file, required for Pegasus to open your games with an emulator. 

During the execution of this operation, you will be prompted for a second time to edit a text file with nano. 

For a list of launch commands, you may refer to this: https://pegasus-frontend.org/tools/metagen-android/

4. Configure Pegasus to be able to launch your games
