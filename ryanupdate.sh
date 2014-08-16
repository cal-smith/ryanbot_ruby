#!/bin/bash

#kill all the ryanbot processes
ps | grep ryanbot3.rb | grep -v grep | awk '{print $1}' | xargs kill
ps | grep ryanbot3all.rb | grep -v grep | awk '{print $1}' | xargs kill

#get the new ryanbots
curl https://raw.githubusercontent.com/hansolo669/ryanbot_ruby/master/ryanbot3.rb -o ryanbot3.rb
curl https://raw.githubusercontent.com/hansolo669/ryanbot_ruby/master/ryanbot3all.rb -o ryanbot3all.rb

#bootem!
ruby ryanbot3.rb &
ruby ryanbot3all.rb &
