# encoding: utf-8
require 'snoo'
require 'sqlite3'

$db = SQLite3::Database.new( "ryan.db" )

$db.execute("CREATE TABLE IF NOT EXISTS ryan ( id VARCHAR(255) PRIMARY KEY);")

def nice
	puts "sleeping for 4 seconds"
	sleep 4
end

def tip(tippet, tipper, id, amount)
	$db.execute("INSERT INTO ryan (id) VALUES (?)", id)
	puts "tipping"
	puts "tipper: " << tipper
	puts "tippet: " << tippet
	puts "reply to: " << id
	id = "t1_" << id
	puts "amount ryan: " << amount[0]
	text = "[✓] Accepted: #{tipper} → #{amount[0]} ryan (R#{amount[0]} ryan ryancoins) → #{tippet}"
	$ryan.comment(text, id)
	nice
	puts "sending PM"
	$ryan.send_pm tippet, "YOU GOT TIPPED #{amount} RYAN COINS!", "YAY FOR YOU!"
	nice
end

def connection
	puts "connection problems, polling reddit"
	begin
		$ryan.me
	rescue Exception => e
		puts e
		puts "sleeping for 10"
		sleep 10
		connection
	end
end

begin
	$ryan = Snoo::Client.new({:user_agent => "RYANBOT for /r/all by /u/hansolo669", :username => "ryantipbot", :password => ""})
rescue Exception => e
	puts e
end

def tipbot
	while true
		begin
			comments = $ryan.get_comments({:subreddit =>'all'})
			$ryan.me
			comments = comments["data"]["children"]
		rescue Exception => e
			puts e
			connection
		end
		nice
		comments.each do |comment|
			unless comment["data"]["subreddit"] = "CrispyPops"
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
						comments = $ryan.get_comments({:subreddit => 'all', :link_id => link, :comment_id => parent})
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
		end
	end
end

tipbot