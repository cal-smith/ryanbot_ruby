#!/bin/bash

#kill all the ryanbot processes
ps | grep ryanbot2.rb | grep -v grep | awk '{print $1}' | xargs kill
ps | grep ryanbot2all.rb | grep -v grep | awk '{print $1}' | xargs kill

#get the new ryanbots
curl https://raw.githubusercontent.com/hansolo669/ryanbot_ruby/master/ryanbot2.rb -o ryanbot2.rb
curl https://raw.githubusercontent.com/hansolo669/ryanbot_ruby/master/ryanbot2all.rb -o ryanbot2all.rb

#bootem!
ruby ryanbot2.rb &
ruby ryanbot2all.rb &
