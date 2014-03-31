class LogFile
    # All methods for handling log files will now be included into this class
    # This class will have all the methods for parsing the log files and returning the required information (IP address, stats, etc)
    
    def initialize(logLocation)
        @logLocation = logLocation
    end
    
    def getIPs()
        # Goes line by line through a given file taking out and striping the line to the required information
        #       if it matches the requirements, it prays on the reliable logging standard by the Essentials Bukkit plugin
        
        # There is an obvious problem however, at the moment it only checks for the string "logged in with entity"
        #       but it doesn't check anything else so if a user were to say the string in chat, it would be logged and this function
        #       would try and parse it.  This needs to be fixed in a future version that will make use of regex
        
        if File.extname(@logLocation) == ".gz"
            file_gz = Zlib::GzipReader.open(@logLocation)                           # If the file is a .gz file it will be read line by line, using the zlib library
            fileContent = file_gz.readlines()                                  # Each line is add to the the array fileContent
        else
            fileContent = IO.readlines(@logLocation)
        end
            entries = []                                                                    # This will hold the end data after it has been extracted
        for i in (0...fileContent.length)
        if fileContent[i].include? "logged in with entity"    # This needs to be replaced by a regex.  
            loggedip = fileContent[i].split[3]                             # finds the username and IP in the given line and then snips away the excess data
            username = loggedip.split("[")[0]
            loggedip = loggedip.split("[")[1].split(":")[0]
            loggedip.slice!("/")
            entries.push("#{loggedip},#{username}\n")      # Add the data to the entries array in a csv style eg "127.0.0.1,username"
        end
        end
        return entries                                                                # Returns the array of snipped data
    end
    
    def getLocation()
        # Returns the location of the file object
        return File.realpath(@logLocation)    
    end
end
