#!/usr/bin/ruby1.9.1

require "./lib/revIP"
require "./lib/updateDB"

if ARGV.first == nil
    puts "Welcome to the Minecraft Log File Manager"
    puts "Use the \"-?\" flag more for usage options"
elsif ARGV.first == "-?"
    puts "Minecraft Log File Manager usage"
    puts
    puts "  -?              - Shows the usage options"
    puts
    puts "--- Reverse IP ---"
    puts
    puts "  -u [database]   - Update the ip adress database"
    puts "  -r [player/ip]  - Search the ip database for user or IP"
    puts
    puts "--- First Join ---"
    puts 
    puts "  -f <player>     - Shows the date that a player first joined"
    puts
elsif ARGV.first == "-u"
    u = UpdateDB.new()
    u.run(ARGV[1...ARGV.length])
elsif ARGV.first == "-r"
    r = RevIP.new()
    r.run(ARGV[1...ARGV.length])
elsif ARGV.first == "-f"
    if ARGV[1] != nil
        puts "To be implemented"
    else
        puts "Please provide a user name"
    end
else
    puts "Incorrect usage. Please use the \"-?\" flag for more usage options"
end
