# encoding: utf-8
require 'snoo'
require 'sqlite3'
require 'logger'
require 'json'

config = File.read("config.json")
config = JSON.parse(config)
$pass = config["pass"]

$log = Logger.new('ryan.log', 20, 'daily')

$db = SQLite3::Database.new( "ryan.db" )

$db.execute("CREATE TABLE IF NOT EXISTS ryan ( id VARCHAR(255) PRIMARY KEY);")
$db.execute("CREATE TABLE IF NOT EXISTS tip_total ( id VARCHAR(255) PRIMARY KEY, balance);")

def nice
	puts "sleeping for 4 seconds"
	sleep 4
end 

def tip(tippet, tipper, id, amount)
	begin
		$db.execute("INSERT INTO ryan (id) VALUES (?)", id)
	rescue => e
		puts e
	end
	puts "tipping"
	puts "tipper: " << tipper
	puts "tippet: " << tippet
	puts "reply to: " << id
	id = "t1_" << id
	puts "amount ryan: " << amount[0]
	text = "[✓] Accepted: #{tipper} → #{amount[0]} ryan (R#{amount[0]} ryan ryancoins) → #{tippet}"
	begin
		$ryan.comment(text, id)
		nice
		puts "sending PM"
		$ryan.send_pm tippet, "YOU GOT TIPPED #{amount} RYAN COINS!", "YAY FOR YOU!"
		nice
	rescue => e
		$log.error("there was an issue posting the comment #{e}")
		puts "there was an issue posting the comment, re-trying"
		tip(tippet, tipper, id, amount)
	end
end

def tip_total
end

def connection
	puts "connection problems, polling reddit"
	$log.debug "connection problems, polling reddit"
	begin
		$ryan.me
	rescue => e
		puts e
		puts "sleeping for 10"
		sleep 10
		connection
	end
end

def login
	puts "logging in/re-auth"
	begin
		$ryan = Snoo::Client.new({:user_agent => "RYANBOT2 by /u/hansolo669", :username => "ryantipbot", :password => $pass})
	rescue => e
		$log.error("issue logging in #{e}")
		puts e
	end
end

def tipbot
	while true
		login
		nice
		begin
			comments = $ryan.get_comments({:subreddit =>'CrispyPops+mcham'})
			if comments["error"]
				puts comments["error"]
				puts "there was an error not caught(404 504), re-trying connection"
				connection
			end
			$ryan.me
			comments = comments["data"]["children"]
		rescue => e
			$log.error("issue with getting comments #{e}")
			puts e
			connection
		end
		nice
		if comments.empty?
			$log.error("comments are empty")
			puts "couldnt get comments for some reason"
			connection
		end
		begin
			comments.each do |comment|
				if /\/u\/ryantipbot/i.match(comment["data"]["body"])
					puts "potential tipper: " << comment["data"]["author"]
					id = comment["data"]["id"]
					findid = $db.execute("SELECT * FROM ryan WHERE id = ?", id)
					if findid.empty?
						tipper = comment["data"]["author"]
						amount = comment["data"]["body"]
						amount = /\d+ ryan/i.match(amount)
						amount = amount[0].match(/\d+/)
						puts amount
						link = comment["data"]["link_id"]
						link[0..2] = ''
						puts "link: " << link
						parent = comment["data"]["parent_id"]
						parent[0..2] = ''
						puts "parent: " << parent
						puts "now to get comments"
						comments = $ryan.get_comments({:subreddit => 'CrispyPops+mcham', :link_id => link, :comment_id => parent})
						if link == parent
							puts "link/selfpost"
							tippet = comment["data"]["link_author"]
							tip(tippet, tipper, id, amount)
						else
							puts "pulling that comment author"
							tippet = comments[1]["data"]["children"][0]["data"]["author"]
							puts tippet
							tip(tippet, tipper, id, amount)
						end
					else
						puts "skip!"
					end
				end
			end
		rescue Exception => e
			$log.error("died with #{e}")
		end
	end
end



login

tipbot