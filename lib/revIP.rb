#!/usr/bin/ruby

=begin
This ruby script is for displaying the contents with filters of the ipdb.csv file.  See the README for more information

Author = Joseph Laycock
git = www.github.com/lankyninja/McReverseIP
=end


class RevIP
    def initialize()
        @IPDATABASE = @@IPDATABASE
    end
    
    def dumpDB()
        # Reads the entire database and prints every entry (Not reccomended for larger databases)
        db = File.open(@IPDATABASE,"r")
        puts db.readlines()
        db.close()
    end

    def dumpFilteredDB(filter)
        # Reads each line, if the line at any point matches the filter, it will display it to screen
        #   (eg a filter of "lanky" will show the users "lanky","lankyninja","superlankyman")
        #   The filter also applies to the IP address (eg a filter of "22" will show "192.168.22.1","162.54.35.22" or even "superuser22")    
        db = File.open(@IPDATABASE,"r")
        line = db.readlines()
        for i in(0...line.length)                                           # For everyline
        for ifilter in filter                                                # Check each filter
            if line[i].include? ifilter                                    # if it is in the currentline
            puts line[i]                                                  # print to screen if it is
            end
        end
        end
        db.close()
    end
    
    def run(filter)
        if File.exist?(@IPDATABASE)                                         # If the file exists, continue
            if filter.length == 0
                dumpDB()                                                            # No arguments dump the entire thing
            else
                dumpFilteredDB(filter)                                        # Otherwise use each argument as a filter
            end
        else
            puts "Database doesn't exist yet, try running updateDB.rb"
        end
    end
end