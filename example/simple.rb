require 'rubygems'
require 'runkeeper_activities'

puts "Enter RunKeeper username: "
username = gets.strip
puts ""

runkeeper_user = RunKeeperActivities::User.find_by_username(username)
runkeeper_user.activities[0...5].each do |a|
  puts "* On #{a.start_time.strftime("%A %d %B")} #{a.summery}"
  puts "  Duration: #{a.duration} #{a.user.duration_unit} - Avg. speed: #{a.speed} #{a.user.speed_unit}"
  puts ""
end
