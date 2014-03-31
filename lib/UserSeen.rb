#!/usr/bin/ruby

=begin
This ruby script is for updating or creating the userdb.csv file.  See the README for more information

Author = Joseph Laycock
git = www.github.com/lankyninja/McReverseIP
=end

require 'zlib'                    #for reading the .gz files
require './lib/logFiles'

#Constants you might want to change
#
# shouldn't have to change anything below this point
#
class UserSeen
    def initialize()
        @LOGSLOCATION = @@LOGSLOCATION                  #default location of the logs to be parsed
        @LOGFILES = []                    #List to hold the file names of the parsed logs
        
        Dir.foreach(@@LOGSLOCATION) do |i|
            if File.extname(i) == '.log' or File.extname(i) == '.gz'
               location = @@LOGSLOCATION+i
               @LOGFILES.push(LogFile.new(location))
            end
        end
        
    end
    
    def getDateSeen(user)
        usernames = []
        namesighted = []
        nameonly = []
        for i in (@LOGFILES)
            for x in (i.getUsers())
                usernames.push(x)
                filename = i.getFileName().split("-")
                date = "#{filename[2]}/#{filename[1]}/#{filename[0]}"
                namesighted.push("#{date},#{x}")
            end
        end
        namesighted.uniq!
        if user != nil
            for i in (namesighted)
                if i.include?(user)
                    nameonly.push(i)
                end
            end
            return nameonly
        else
            return namesighted
        end
    end
end
