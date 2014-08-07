ryanbot_ruby
============

ITS RYANTIPBOT!

Ryanbot runs on Ruby, [paradox460's snoo](https://github.com/paradox460/snoo), sqlite3 and the sqlite3 gem.  
The json and logger gems are also along for the ride.

ryanbot2.rb is currently the most up to date bot, as ryanbot2all needs some extra work to enusre it gets the correct comments from /r/all (currently the 4 second delay is too long as we miss some comments, however we still have to respect reddits api rules).

ryanupdate.sh pulls the latest ryanbots from github and starts them. It is currently kicked off by an upstart sript. (Note: merge script and upstart conf)
