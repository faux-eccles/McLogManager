#!/usr/bin/ruby

require 'zlib'

@IPDATABASE = "./ipdb.csv"
@LOGSLOCATION = "./"
@LOGFILES = []
@GROUPID = 1000

if ARGV.first == nil
    Dir.foreach(@LOGSLOCATION) do |i|
        if File.extname(i) == '.log' or File.extname(i) == '.gz'
           location = @LOGSLOCATION+i
           #puts location
           @LOGFILES.push(location)
        end
    end
else
    @LOGFILES = ARGV
end

def parseEntriesFromLogs(logs)
    if File.extname(logs) == ".gz"
        file_gz = Zlib::GzipReader.open(logs)
        file_content = file_gz.readlines()
    else
        file_content = IO.readlines(logs)
    end
    $entries = []
    for i in (0...file_content.length)
        if file_content[i].include? "logged in with entity"
            loggedip = file_content[i].split[3]
            username = loggedip.split("[")[0]
            loggedip = loggedip.split("[")[1].split(":")[0]
            loggedip.slice!("/")
            $entries.push("#{loggedip},#{username}\n")
        end
    end
    return $entries
end

def updateDB()
    if File.exist?(@IPDATABASE) == false
        f = File.new(@IPDATABASE,"a+")
    else
        f = File.open(@IPDATABASE,"a+")
    end
    
    for i in (0...@LOGFILES.length)
	print "Working with: #{File.realpath(@LOGFILES[i])}"
        entries = parseEntriesFromLogs(@LOGFILES[i])
        entries = entries.uniq
        for i in (0...entries.length)
            f.write(entries[i])
        end
        puts " - Done"
    end
    f.close()
    File.chown(-1,@GROUPID,@IPDATABASE)
    File.chmod(0664,@IPDATABASE)
end

def cleanup()
        if File.exist?(@IPDATABASE) == false
        puts "No file to clean"
        return false
    else
        f = File.open(@IPDATABASE,"r")
        entries = f.readlines()
        f.close()
        f = File.open(@IPDATABASE,"w+")
        
        entries = entries.uniq
        for i in (0...entries.length)
            f.write(entries[i])
        end
        f.close()
    end
end

updateDB()
cleanup()
