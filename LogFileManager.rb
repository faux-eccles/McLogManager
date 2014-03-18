#!/usr/bin/ruby

require "./lib/revIP"
require "./lib/updateDB"

if ARGV.first == nil
    puts "Welcome to the Minecraft Log File Manager"
    puts "Use the \"-?\" flag more for usage options"
elsif ARGV.first == "-?"
    puts "Minecraft Log File Manager usage"
    puts
    puts "  -?              - Shows the usage options"
    puts "  -u              - Update the ip adress database"
    puts "  -r [player/ip]  - search the ip database for user or IP"
    puts
elsif ARGV.first == "-u"
    u = UpdateDB.new()
    u.run(ARGV[1...ARGV.length])
elsif ARGV.first == "-r"
    r = RevIP.new()
    r.run(ARGV[1...ARGV.length])
else
    puts "Incorrect usage. Please use the \"-?\" flag for more usage options"
end
