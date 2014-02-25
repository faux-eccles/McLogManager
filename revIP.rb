#!/usr/bin/ruby

@IPDATABASE = './ipdb.csv'

def dumpDB()
    db = File.open(@IPDATABASE,"r")
    puts db.readlines()
    db.close()
end

def dumpFilteredDB(filter)
    db = File.open(@IPDATABASE,"r")
    line = db.readlines()
    for i in(0...line.length)
        for ifilter in filter
            if line[i].include? ifilter
                puts line[i] 
            end
        end
    end
    db.close()
end

if File.exist?(@IPDATABASE) 
    if ARGV.first == nil
        dumpDB()
    else
        dumpFilteredDB(ARGV)
    end
else
    puts "Datbase doesn't exist yet, try running updateDB.rb"
end
