#Minecraft Log Manager

Mc Log Manager is a system written in ruby designed to parse the Bukkit Essentials logs files and perform different actions on them, such as Reverse IP which will let you search for all users that have signed on under an IP or all the IP's that a user has logged in under

##**LogFileManager.rb**

This is the main program.  It will import all the different log file processes from the lib/ folder

Usage:

```
./LogFileManager.rb <flag>
```

for a complete list of flags use 

```
$ ./LogFileManager.rb -?
Minecraft Log File Manager usage

  -?              	- Shows the usage options
  -u              	- Update the ip adress database
  -r [player/ip]  	- search the ip database for user or IP
```

