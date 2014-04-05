# encoding: utf-8
require 'snoo'

$ryan = Snoo::Client.new({:user_agent => "RYANBOT by /u/hansolo669", :username => "ryantipbot", :password => ""})

def nice
	puts "sleeping for 4 seconds"
	sleep 4
end

def tip(tippet, tipper, id, amount)
	puts "tipper: " << tipper
	puts "tippet: " << tippet
	puts "reply to: " << id
	id = "t1_" << id
	puts "amount ryan: " << amount[0]
	text = "[✓] Accepted: #{tipper} → #{amount[0]} ryan (R#{amount[0]} ryan ryancoins) → #{tippet}"
	$ryan.comment(text, id)
	nice
end

#$ryan.log_in 'ryantipbot', 'MOOMAN'
#nice

comments = $ryan.get_comments({:subreddit =>'crispypops'})
nice
comments = comments["data"]["children"]
comments.each do |comment|
	if /ryantipbot/i.match(comment["data"]["body"])
		puts "potential tipper: " << comment["data"]["author"]
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
		id = comment["data"]["id"]
		puts "now to expend a api call to check is ryanbot has replied immedietly below"
		comments = $ryan.get_comments({:subreddit => 'crispypops', :link_id => link, :comment_id => parent})
		nice
		reply = comments[1]["data"]["children"][0]["data"]["replies"]["data"]["children"][0]["author"]
		puts reply
		unless reply == "ryantipbot"
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
		end
	end
end