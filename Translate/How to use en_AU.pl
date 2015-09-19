How to use en_AU.pl

In your /home directory create a folder (e.g. Gnome) and within that folder create another one (e.g. Gnome3.4) and another
within to suit Gnome's structure. My setup for Gnome 3.4 is /home/username/Gnome/Gnome3.4/ui and 
home/username/Gnome/Gnome3.4/ui-translated. I do this for each of Gnome's particular translation areas like ui, 
ocumentation etc. Now within the folder with all the .po or .pot files create another folder called Translated. This folder
is where all your translated files will be placed. If you haven't created the folder thescript will not work. Place en_AU.pl
in the folder with all the .po and .pot files.

All you need to do now is make the file executable. Double click on it to run in terminal and it will go through each file
and translate most words and give you options on others. Once each file is completed it will be placed in the Translated
folder for you to check over.

There is 1 bug, that doesn't bother me at all, and that is the script usually misses the last line in each .po or .pot file
so you will need to check it and manually translate the remaining lines. 1 other bug is it will ocassionaly mix lines in
translated file. It is always good practise, and this 2nd bug makes it so much more important, to check each file for
errors before you submit them.

You will see in the word list many words commented out with ## marks in front of them. I have done this because some are
simply not relevant to this purpose but are used by others who can "uncomment" them is they wish to in their own copies of
this file.

Please feel free to suggest additions and changes.
