require 'snooby'

puts "k"

ryan = Snooby::Client.new('RYANBOT by /u/hansolo669')
ryan.authorize!('ryantipbot', '')

while true
	ryan.r('crispypops').comments.each do |comment|
		parent = comment.parent_id
		link = comment.link_id
		ryan.r('crispypops').comments(link).each do |find|
			if find.parent_id == parent
				tippet = find.author
				puts tippet
				break;
			end
		end
	end
end