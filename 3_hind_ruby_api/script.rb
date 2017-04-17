#!/usr/bin/env ruby
require "oauth2"

module Constants
  URL				= "https://api.intra.42.fr"
  UID_42			= ENV.fetch("FT42_UID")
  SECRET_42			= ENV.fetch("FT42_SECRET")
end

class Token
	include Constants

	attr_reader :token

	def initialize
		client = OAuth2::Client.new(UID_42, SECRET_42, site: URL)
		@token = client.client_credentials.get_token
	end
end

token = Token.new.token

zone = Array.new(6)
zone[0]				= "/******|******\\\n| \033[31;1m????\033[0m | \033[31;1m????\033[0m |\n|------|------|\n| \033[31;1m????\033[0m | \033[31;1m????\033[0m |\n|******|******/\n| \033[31;1mUNAVAILABLE\033[0m/\n|-----------/\n"
zone[1]				= "/******|******\\\n|      | \033[32mHERE\033[0m |\n|------|------|\n|      |      |\n|******|******/\n|    \033[33mbocal\033[0m   /\n|-----------/\n"
zone[2]				= "/******|******\\\n|      |      |\n|------|------|\n|      | \033[32mHERE\033[0m |\n|******|******/\n|    \033[33mbocal\033[0m   /\n|-----------/\n"
zone[3]				= "/******|******\\\n|      |      |\n|------|------|\n| \033[32mHERE\033[0m |      |\n|******|******/\n|    \033[33mbocal\033[0m   /\n|-----------/\n"
zone[4]				= "/******|******\\\n| \033[32mHERE\033[0m |      |\n|------|------|\n|      |      |\n|******|******/\n|    \033[33mbocal\033[0m   /\n|-----------/\n"
zone[5]				= "\033[0;36m▓█████▄  ▒█████  ▓█████   ██████     ███▄    █  ▒█████  ▄▄▄█████▓    ▄████▄   ▒█████   ███▄ ▄███▓ ██▓███   █    ██ ▄▄▄█████▓▓█████ \n▒██▀ ██▌▒██▒  ██▒▓█   ▀ ▒██    ▒     ██ ▀█   █ ▒██▒  ██▒▓  ██▒ ▓▒   ▒██▀ ▀█  ▒██▒  ██▒▓██▒▀█▀ ██▒▓██░  ██▒ ██  ▓██▒▓  ██▒ ▓▒▓█   ▀ \n░██   █▌▒██░  ██▒▒███   ░ ▓██▄      ▓██  ▀█ ██▒▒██░  ██▒▒ ▓██░ ▒░   ▒▓█    ▄ ▒██░  ██▒▓██    ▓██░▓██░ ██▓▒▓██  ▒██░▒ ▓██░ ▒░▒███   \n░▓█▄   ▌▒██   ██░▒▓█  ▄   ▒   ██▒   ▓██▒  ▐▌██▒▒██   ██░░ ▓██▓ ░    ▒▓▓▄ ▄██▒▒██   ██░▒██    ▒██ ▒██▄█▓▒ ▒▓▓█  ░██░░ ▓██▓ ░ ▒▓█  ▄ \n░▒████▓ ░ ████▓▒░░▒████▒▒██████▒▒   ▒██░   ▓██░░ ████▓▒░  ▒██▒ ░    ▒ ▓███▀ ░░ ████▓▒░▒██▒   ░██▒▒██▒ ░  ░▒▒█████▓   ▒██▒ ░ ░▒████▒\n ▒▒▓  ▒ ░ ▒░▒░▒░ ░░ ▒░ ░▒ ▒▓▒ ▒ ░   ░ ▒░   ▒ ▒ ░ ▒░▒░▒░   ▒ ░░      ░ ░▒ ▒  ░░ ▒░▒░▒░ ░ ▒░   ░  ░▒▓▒░ ░  ░░▒▓▒ ▒ ▒   ▒ ░░   ░░ ▒░ ░\n ░ ▒  ▒   ░ ▒ ▒░  ░ ░  ░░ ░▒  ░ ░   ░ ░░   ░ ▒░  ░ ▒ ▒░     ░         ░  ▒     ░ ▒ ▒░ ░  ░      ░░▒ ░     ░░▒░ ░ ░     ░     ░ ░  ░\n ░ ░  ░ ░ ░ ░ ▒     ░   ░  ░  ░        ░   ░ ░ ░ ░ ░ ▒    ░         ░        ░ ░ ░ ▒  ░      ░   ░░        ░░░ ░ ░   ░         ░   \n   ░        ░ ░     ░  ░      ░              ░     ░ ░              ░ ░          ░ ░         ░               ░                 ░  ░\n ░                                                                  ░\n\033[0m"

if ARGV.size < 1
	puts "Too few arguements. Include at least one file or username"
	exit
else
	puts "Lets find your user(s)...."
	ARGV.each do |arg|
		if File.exist?(arg)
			f = File.open(arg, "r").read
			f.each_line do |line|
				cut = line.chomp
				begin
					idlocation =  token.get("/v2/users/#{cut}/locations", params: {page: {number: 1}})
					idlocation.status
				rescue
					puts "\033[31;1mThis user-->\033[0m"+cut+"\033[31;1m<-- does not a exist\033[0m"
					puts zone[5]
					next
				end
				location = idlocation.parsed.first
				if location["end_at"] == nil
					p
					puts cut+': '+location["host"]
					puts zone[location["host"][3].to_i]
				else
					puts cut+': UNAVAILABLE'
					puts zone[0]
				end
			end
		else
			puts "File doesn't exit, how about we try the username"
			begin
				idlocation =  token.get("/v2/users/#{arg}/locations", params: {page: {number: 1}})
				idlocation.status
			rescue
				puts "\033[31;1mThis user-->\033[0m"+arg+"\033[31;1m<-- does not a exist\033[0m"
				puts zone[5]
				next
			end
			location = idlocation.parsed.first
			location = token.get("/v2/users/#{arg}/locations", params: {page: {number: 1}}).parsed.first
			if location["end_at"] == nil
				p
				puts arg+': '+location["host"]
				puts zone[location["host"][3].to_i]
			else
				puts arg+': UNAVAILABLE'
				puts zone[0]
			end
		end
	end
end
