#!/usr/bin/env ruby
require 'net/smtp'
Net.instance_eval {remove_const :SMTPSession} if defined?(Net::SMTPSession)
require 'net/pop'
Net::POP.instance_eval {remove_const :Revision} if defined?(Net::POP::Revision)
Net.instance_eval {remove_const :POP} if defined?(Net::POP)
Net.instance_eval {remove_const :POPSession} if defined?(Net::POPSession)
Net.instance_eval {remove_const :POP3Session} if defined?(Net::POP3Session)
Net.instance_eval {remove_const :APOPSession} if defined?(Net::APOPSession)
require 'tlsmail'

G_USERNAME      = ENV.fetch("GMAIL_USERNAME")
G_SECRET        = ENV.fetch("GMAIL_SECRET")
marker = "AUNIQUEMARKER"

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def red
    colorize(31)
  end

  def green
    colorize(32)
  end

  def yellow
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def pink
    colorize(35)
  end

  def light_blue
    colorize(36)
  end
end

class Main_user
	def initialize(your_email, secret)
		@your_email = your_email
		@secret = secret
	end

	def new_secret(secret)
		puts 'What is your Google Apps Password?'.green
		system 'stty -echo'
		secret = $stdin.gets.chomp
		system 'stty echo'
	end

	def email_check(your_email)
		if G_USERNAME == your_email
			return 0
	  else
	  	return 1
	  end
	end
end

def your_name(from)
	puts 'Who is this email from?'.green
	from = STDIN.gets.chomp
end

def their_name(to)
	puts 'What is the recipients name?'.green
	your_email = STDIN.gets.chomp
end

def send_from(your_email)
	puts 'What is your email address?'.green
	your_email = STDIN.gets.chomp	
end

def send_to(their_email)
	puts 'What is the recipients email address?'.green
	their_email = STDIN.gets.chomp
end

def what_about(subject)
	puts 'What would you like in the subject text?'.green
	subject = STDIN.gets.chomp
end

def multi_gets all_text=""
  while all_text << STDIN.gets
    return all_text if all_text["\n\n\n"]
  end
end

def context(body)
	puts "What would you like in the body text? You can use either HTML/text. Type enter 3 times when you are finished".green
	body = multi_gets()
end

def compile_msg(message, from, to, your_email, their_email, subject, body, marker)
	message = <<EOF
From: #{from} <#{your_email}>
To: #{to} <#{their_email}>
Subject: #{subject}
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary=#{marker}
--#{marker}
Content-type: text/html
Content-Transfer-Encoding:8bit

#{body}
--#{marker}
EOF
end

def file_check
	puts 'What is the absolute path to the file?'.green
  begin
    counter ||= 3
    path = STDIN.gets.chomp
    newpath = File.expand_path(path)
    if !File.exists? newpath
      raise StandardError
    end
  rescue
    if (counter -= 1) > 0
      puts 'That file or directory does not exit. Please try entering the correct filename/directory.'.yellow
      retry
    else
      puts 'Please try running the script again.'.red
    end
    exit
  end
  return (newpath)
end

def appendit(filename, file_content, message, marker)
puts marker
	encoded_content = [file_content].pack("m")
str =<<EOF
Content-Type: multipart/mixed; name=\"#{filename}\"
Content-Transfer-Encoding:base64
Content-Disposition: attachment; filename="#{filename}"

#{encoded_content}
--#{marker}--
EOF
	message = message + str
	return message
end

def attach_file(message, marker)
	puts "Would you like to add an attachment to your email?\n (\'1\') Yes\n (\'0\') No".yellow
	if STDIN.gets.to_i == 1
		counter ||= 3
		filename = file_check
		puts filename
  	file_content = File.read(filename)
		if file_content
			puts 'here'
			message = appendit(filename, file_content, message, marker)
		end
	else
	end
	return message
end

def show_msg(message)
	puts 'This is what your message will look like'.yellow
	puts '--------------------------------------------------------------------'.blue
	puts message.green
	puts '--------------------------------------------------------------------'.blue
	puts 'Take a sec to review your email, then press enter when you\'re done'.red
	STDIN.gets
end

def confirm(yes)
	puts "Do you want to send this message?\n (\'1\') Yes\n (\'0\') No".yellow
	yes = STDIN.gets.to_i
end

def send_msg(msgstr, your_email, their_email, secret)
	begin
		counter ||= 3
		Net::SMTP.enable_tls(OpenSSL::SSL::VERIFY_NONE)
		Net::SMTP.start("smtp.gmail.com", 587, "gmail.com", your_email, secret, :plain) do |smtp|
		  smtp.send_message msgstr, your_email, their_email
		end
	rescue
    if (counter -= 1) > 0
      puts 'There seems to be an error connecting. Let\'s try again'.yellow
      retry
    else
      puts 'Please try running the script again.'.red
    end
    exit
	end
end

main_email = Main_user.new(G_USERNAME, G_SECRET)

if ARGV.size > 0
  puts 'Too many arguments. Please just run the script on its own'.red
  puts 'usage: ./proj_script.rb'.red
  exit
else
  puts 'Alright lets see if this works'.green
  from = your_name(from)
  to = their_name(to)
  your_email = send_from(your_email)
  if main_email.email_check(your_email) == 0
  	secret = G_SECRET
  else
  	secret = main_email.new_secret(secret)
  end
  their_email = send_to(their_email)
  subject = what_about(subject)
  body = context(body)
  message = compile_msg(message, from, to, your_email, their_email, subject, body, marker)
  message = attach_file(message, marker)
  show_msg(message)
  check = confirm(check)
  if check == 1
  	send_msg(message, your_email, their_email, secret)
  else
		exit
	end
end
