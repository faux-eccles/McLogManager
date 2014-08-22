#!/usr/bin/ruby1.9.1

require_relative "lib/revIP"
require_relative "lib/updateIPDB"
require_relative "lib/UserSeen"

@@LOGSLOCATION = File.dirname(__FILE__)+"/logs/"                  #default location of the logs to be parsed
@@IPDATABASE = File.dirname(__FILE__)+'/ipdb.csv'
@@GROUPID = 1000                           #UNIX groupid for changing who has access to the data base 


if ARGV.first == nil
    puts "Welcome to the Minecraft Log File Manager"
    puts "Use the \"-?\" flag more for usage options"
elsif ARGV.first == "-?"
    puts "Minecraft Log File Manager usage"
    puts
    puts "  -?               - Shows the usage options"
    puts
    puts "--- Reverse IP ---"
    puts
    puts "  -u [database]    - Update the ip adress database"
    puts "  -r [player/ip]   - Search the ip database for user or IP"
    puts
    puts "--- Date seen ---"
    puts 
    puts "  -s [player/date] - Shows the dates that a player has connected (relies on the default bukkit log config)"
    puts
elsif ARGV.first == "-u"
    u = UpdateIPDB.new()
    u.run(ARGV[1...ARGV.length])
elsif ARGV.first == "-r"
    r = RevIP.new()
    r.run(ARGV[1...ARGV.length])
elsif ARGV.first == "-s"
    s = UserSeen.new()
    puts s.getDateSeen(ARGV[1])
else
    puts "Incorrect usage. Please use the \"-?\" flag for more usage options"
end
