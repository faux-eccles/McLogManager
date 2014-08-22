#!/usr/bin/ruby

=begin
This ruby script is for updating or creating the ipdb.csv file.  See the README for more information

Author = Joseph Laycock
git = www.github.com/lankyninja/McReverseIP
=end

require 'zlib'                    #for reading the .gz files
require_relative 'logFiles'

#Constants you might want to change
#
# shouldn't have to change anything below this point
#
class UpdateIPDB
    def initialize()
        @IPDATABASE = @@IPDATABASE            #location and file name for the file the data will be stored in
        @LOGSLOCATION = @@LOGSLOCATION                  #default location of the logs to be parsed
        @LOGFILES = []                    #List to hold the file names of the parsed logs
        @GROUPID = @@GROUPID                          #UNIX groupid for changing who has access to the data base 

    end
    
    def updateDB()
        # Update the ipdb file as specified in IPDATABASE.  This will append the new data to the end of the file if it exists
        #       otherwise it will create a new file at the given location and update that.  Once the file is saved the group ownership is modified
        #       and the group policy for the file is modified so that users who belong to that group can read from and write to that file.
        #       The group ID is specified at the top of the program.
        
        # Need to add in a -v flag to opt out of messages that show what file is being accessed
        
        # This may be re written into a general class for file handling, merging with the revIP.rb
        
        if File.exist?(@IPDATABASE) == false                                # Check for files existance, if it doesn't
        f = File.new(@IPDATABASE,"a+")                                   # Create a new one
        else
        f = File.open(@IPDATABASE,"a+")                                  # Otherwise use the specified one
        end
        
        for i in (0...@LOGFILES.length)                                        # For every file given, run that file through parseEntriesFromLog()
        print "Working with: #{@LOGFILES[i].getLocation()}"
        entries = @LOGFILES[i].getIPs()
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

    def run(args)
        if args.length == 0                            #If there was no arguments, make an array of the valid files located in @LOGSLOCATION
            Dir.foreach(@LOGSLOCATION) do |i|
            if File.extname(i) == '.log' or File.extname(i) == '.gz'
               location = @LOGSLOCATION+i
               @LOGFILES.push(LogFile.new(location))
            end
            end
        else                                    #Otherwse if there was at least one argument, make the array of the given files, 
            for i in (0...args.length)
            if !File.exist?(args[i])                                            #First checks to make sure that the file specified exists
                puts "The file #{args[i]} does not exist"
            elsif File.extname(args[i]) == '.log' or File.extname(args[i]) == '.gz'    # And that it is a supported file type
                @LOGFILES.push(LogFile.new(args[i]))
            else
                puts "No valid log file given"
            end
            end
        end
        updateDB()                                                                           # Run the update function
        cleanup()                                                                              # Polite to clean up after yourself, don't you think?
    end
end