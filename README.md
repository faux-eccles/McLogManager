MC Reverse IP is a system written in ruby designed to parse the Bukkit Essentials logs files and save the ip address of a user into a .csv file.



updateDB.rb

This file is used to populate the ipdb.csv file that is used as the data base. It will save the IP and then the user name seperated by a ','.  Each entry will be put on a new line.

Usage:

	./updateDB.rb <absolute pathname> ...

This will update the db with the log file given in the arguments, many log files may specified at one time by creating a new argument for each file.  Supported file type: ".log" and ".gz"  Both are automatically created by the bukkit essentials plugin.

	./updateDB.rb

Running the program with no agruments will force the program to update the database using all the logs located in the directory specified in @LOGSLOCATION.



revIP.rb

This program is used to search the ipdb.csv database for the specified filter

Usage:

	./revIP.rb <filter> ...

this will only display the matches for the given filter, for more matches add more filters as arguments

	./revIP.rb

not giving any arguments will dump the entire db to screen
