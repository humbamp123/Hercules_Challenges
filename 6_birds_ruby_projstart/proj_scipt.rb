#!/usr/bin/env ruby

libft = "git@github.com:humbamp123/libft.git"
makefile = "git@github.com:humbamp123/Makefile.git"

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

def gitpush(path)
  system "touch '#{path}/.gitignore'"
  system "git -C #{path} add ."
  system "git -C #{path} commit -m 'Start Project'"
  system "git -C #{path} push"
end

def nextpart(arg, path, makefile, libft)
  puts 'AWESOME! Please enter a github url'.green
  begin
    counter ||= 3
    giturl = STDIN.gets.chomp
    system "git clone '#{giturl}' '#{path}'"
    if not File.exists?(path)
      raise StandardError
    end
  rescue
    if (counter -= 1) > 0
      puts 'Git clone did not seem to work. Please try entering the URL again.'.yellow
      retry
    else
      puts 'Please try running the script again.'.red
    end
    exit
  end
  puts 'Do you want to add another git url? If so type (\'1\') and press enter, otherwise type (\'0\').'.green
  another_git = STDIN.gets.to_i
  if another_git == 1
    puts 'Please enter another github url.'.green
    newurl = STDIN.gets.chomp
    system "git -C #{path} remote set-url --add --push origin #{giturl}"
    system "git -C #{path} remote set-url --add --push origin #{newurl}"
    system "git -C #{path} remote add gh #{newurl}"
    system "git -C #{path} remote -v"
  end
  puts "What kind of project is it?\n (\'1\') C\n (\'2\') Shell\n (\'3\') Ruby\n (\'4\') Other\n".green
  proj_type = STDIN.gets.to_i
  if proj_type == 1
    tmp = '/tmp/make'
    if File.exists?(tmp)
      system "rm -rf #{tmp}"
    end
    system "git clone '#{makefile}' '#{tmp}'"
    system "cp #{tmp}/* #{path}"
    puts 'Cool! Do you want to add libft? If so type (\'1\') and press enter, otherwise type (\'0\').'.green
    yesorno = STDIN.gets.to_i
    if yesorno == 1
      system "mkdir '#{path}/src'"
      system "git clone '#{libft}' '#{path}/src/libft'"
      system "mkdir '#{path}/inc'"
      system "touch '#{path}/author' && echo $USER >> #{path}/author"
      system "touch '#{path}/run' && echo 'make -C src/lib/libft/ re\nmake re\nclang -Wall -Wextra -Werror -I includes/ -o main.o -c main.c -g \nclang -o test_#{arg} main.o src/lib/lib#{arg}.a -I includes/ src/lib/libft/ -lft -g \nrm main.o' >> #{path}/run"
      system "rm -rf '#{path}/src/lib/libft/.git'"
      gitpush(path)
    else
      puts 'No libft, OK!'
      system "mkdir '#{path}/includes'"
      system "mkdir '#{path}/src'"
      system "touch '#{path}/author' && echo $USER >> #{path}/author"
      system "touch '#{path}/run' && echo 'make re\nclang -Wall -Wextra -Werror -I includes/ -o main.o -c main.c -g \nclang -o test_#{arg} main.o lib#{arg}.a -I includes/ -g \nrm main.o' >> #{path}/run"
      gitpush(path)
    end
  elsif proj_type == 2
    system "touch '#{path}/author' && echo $USER >> #{path}/author"
    system "touch '#{path}/#{arg}.sh' && echo '#!/bin/sh\n # Insert stuff below' >> #{path}/#{arg}.sh"
    gitpush(path)
  elsif proj_type == 3
    system "touch '#{path}/author' && echo $USER >> #{path}/author"
    system "touch '#{path}/#{arg}.rb' && echo '#!/usr/bin/env ruby\n # Insert stuff below' >> #{path}/#{arg}.rb"
    gitpush(path)
  else
    system "touch '#{path}/author' && echo $USER >> #{path}/author"
    gitpush(path)
  end
end

def whereareyou (local)
  puts 'Are you at school? If so type (\'1\') and press enter, otherwise type (\'0\').'.green
  answer = STDIN.gets.to_i
  if answer == 1
    home = "~"
    local = home + whereto(local)
  else
    home = "~/Destop"
    local = home + whereto(local)
  end
end

def whereto (dest)
  puts "What kind of project is it?\n (\'1\') Side Project\n (\'2\') Hercules\n (\'3\') School Project\n (\'4\') Other\n".green
  answer = STDIN.gets.to_i
  if answer == 1
    dest = "/"
  elsif answer == 2
    dest = "/Hercules_Challenges/"
  elsif answer == 3
    dest = "/cadet/"
  else
    puts 'Please input a directory'
    newdir = STDIN.gets.chomp
    dest = "/#{newdir}/"
  end
end

def whatdo(arg, path, makefile, libft)
  if File.exists? path
    puts 'File or Folder already exists'.red
    size = Dir.entries(path).length - 2
    if size == 1
      puts 'There is 1 file/directory in this folder'.yellow
    elsif size > 1
      puts 'There are '.yellow + size.to_s.yellow + 'files/directories in this folder'.yellow
    end
    if Dir.entries(path).length > 2
      puts "-------------------------------------------------".light_blue
      Dir.foreach(path) do |f|
        next if f == "." or f == ".."
        i = 1
        puts "file".yellow + " " + i.to_s.yellow + " is ".yellow + f.red
        i = i + 1
      end
      puts "-------------------------------------------------".light_blue
      puts 'The files above are in the folder you are trying to create. If you would like to remove them and continue with the git clone type (\'1\') otherwise, please run the script again and enter a project name that doesn\'t already exist.'.red
      removefiles = STDIN.gets.to_i
      if removefiles == 1
        system "rm -rf #{path}"
        nextpart(arg, path, makefile, libft)
        exit
      else
        puts 'The files were not removed, please run the script again.'.red
        exit
      end
    end
    puts 'If you would still like to git clone to the same directory type (\'1\'), otherwise type (\'0\') and try running the script again'.green
    sure = STDIN.gets.to_i
    if sure == 1
      nextpart(arg, path, makefile, libft)
    else
      puts 'You did not git clone. If you would like to start a new project please run the script again.'.red
      exit
    end
  else
    nextpart(arg, path, makefile, libft)
    puts 'Script complete!'.green
  end
end

if ARGV.size < 1
  puts 'Too few arguments. Please include the name of the project as an argument'.red
  puts 'usage: ./proj_script.rb <project_name>'.red
  exit
elsif ARGV.size > 1
  puts 'Please enter only one project.'.red
  puts 'usage: ./proj_script.rb <project_name>'.red
  exit
else
  puts 'Alright lets see if this works'.green
  location = whereareyou(location)
  ARGV.each do |arg|
    path = File.expand_path("#{location}/#{arg}")
    puts 'Your path is "'.blue + path.green + '"'.blue
    whatdo(arg, path, makefile, libft)
  end
end
