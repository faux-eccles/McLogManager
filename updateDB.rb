#!/usr/bin/ruby

=begin
This ruby script is for updating or creating the ipdb.csv file.  See the README for more information

Author = Joseph Laycock
git = www.github.com/lankyninja/McReverseIP
=end

require 'zlib'	                #for reading the .gz files

#Constants you might want to change

@IPDATABASE = "./ipdb.csv"	        #location and file name for the file the data will be stored in
@LOGSLOCATION = "./"                  #default location of the logs to be parsed
@LOGFILES = []			        #List to hold the file names of the parsed logs
@GROUPID = 1000                           #UNIX groupid for changing who has access to the data base 

#
# shouldn't have anything to change below this point
#

if ARGV.first == nil                            #If there was no arguments, make an array of the valid files located in @LOGSLOCATION
    Dir.foreach(@LOGSLOCATION) do |i|
        if File.extname(i) == '.log' or File.extname(i) == '.gz'
           location = @LOGSLOCATION+i
           @LOGFILES.push(location)
        end
    end
else					                #Otherwse if there was at least one argument, make the array of the given files
    @LOGFILES = ARGV
end

def parseEntriesFromLogs(logs)
        # Goes line by line through a given file taking out and striping the line to the required information
        #       if it matches the requirements, it prays on the reliable logging standard by the Essentials Bukkit plugin
        
        # There is an obvious problem however, at the moment it only checks for the string "logged in with entity"
        #       but it doesn't check anything else so if a user were to say the string in chat, it would be logged and this function
        #       would try and parse it.  This needs to be fixed in a future version that will make use of regex
        
    if File.extname(logs) == ".gz"I
        file_gz = Zlib::GzipReader.open(logs)                           # If the file is a .gz file it will be read line by line, using the zlib library
        file_content = file_gz.readlines()                                  # Each line is add to the the array file_content
    else
        file_content = IO.readlines(logs)
    end
    $entries = []                                                                    # This will hold the end data after it has been extracted
    for i in (0...file_content.length)
        if file_content[i].include? "logged in with entity"    # This needs to be replaced by a regex.  
            loggedip = file_content[i].split[3]                             # finds the username and IP in the given line and then snips away the excess data
            username = loggedip.split("[")[0]
            loggedip = loggedip.split("[")[1].split(":")[0]
            loggedip.slice!("/")
            $entries.push("#{loggedip},#{username}\n")      # Add the data to the $entries array in a csv style eg "127.0.0.1,username"
        end
    end
    return $entries                                                                # Returns the array of snipped data
end

def updateDB()
        # Update the ipdb file as specified in @IPDATABASE.  This will append the new data to the end of the file if it exists
        #       otherwise it will create a new file at the given location and update that.  Once the file is saved the group ownership is modified
        #       and the group policy for the file is modified so that users who belong to that group can read from and write to that file.
        #       The group ID is specified at the top of the program.
        
        # Need to add in a -v flag to opt out of messages that show what file is being accessed
        
        # This maybe re written into a general class for file handling, merging with the revIP.rb
        
    if File.exist?(@IPDATABASE) == false                                # Check for files existance, if it doesn't
        f = File.new(@IPDATABASE,"a+")                                   # Create a new one
    else
        f = File.open(@IPDATABASE,"a+")                                  # Otherwise use the specified one
    end
    
    for i in (0...@LOGFILES.length)                                        # For every file given, run that file through parseEntriesFromLog()
    print "Working with: #{File.realpath(@LOGFILES[i])}"
        entries = parseEntriesFromLogs(@LOGFILES[i])
        entries = entries.uniq                                                    # Remove the duplicate entries in the array 
        for i in (0...entries.length)                                            # write the entries to file
            f.write(entries[i])
        end
        puts " - Done"
    end
    f.close()
    File.chown(-1,@GROUPID,@IPDATABASE)                           # chown (keep the current user,change group to groupID,file to change)
    File.chmod(0664,@IPDATABASE)                                        # chmod (0664 = ?,user-read/write,group-readwrite,other-read)
end

def cleanup()
        # Goes through the database and removes any duplicate entries
        #   Not the best method of doing so I believe but it goes through the entire datase and saves each line into
        #   a new entry of an array.  Runs the .uniq! method of Arrays and then writes the left over lines back in to the file
        
        
    if File.exist?(@IPDATABASE) == false                                # Does it have a file to clean?
        puts "No file to clean"
        return false                                                                # Not sure why it returns false, I guess i may have a use for it later
    else
        f = File.open(@IPDATABASE,"r")                                   # Opens the file as read only and reads the files in the array
        entries = f.readlines()
        f.close()
        f = File.open(@IPDATABASE,"w+")                                 # Re opens the file as write,emptying the file of entries
        
        entries = entries.uniq                                                   # Removes duplicate entries
        for i in (0...entries.length)                                           # Writes the lines to file and saves.
            f.write(entries[i])
        end
        f.close()
        return true
    end
end

updateDB()                                                                           # Run the update function
cleanup()                                                                              # Polite to clean up after yourself, don't you think?