#!/usr/bin/env ruby

libft = "git@github.com:humbamp123/libft.git"
makefile = "git@github.com:humbamp123/Makefile.git"

def gitpush(path)
  system "touch '#{path}/.gitignore'"
  system "git -C #{path} add ."
  system "git -C #{path} commit -m 'Start Project'"
  system "git -C #{path} push"
end

def nextpart(arg, path, makefile, libft)
  puts 'AWESOME! Please enter a github url'
  begin
    counter ||= 3
    giturl = STDIN.gets.chomp
    system "git clone '#{giturl}' '#{path}'"
    if not File.exists?(path)
      raise StandardError
    end
  rescue
    if (counter -= 1) > 0
      puts 'Git clone did not seem to work. Please try entering the URL again.'
      retry
    else
      puts 'Please try running the script again.'
    end
    exit
  end
  puts 'Do you want to add another git url? If so type (\'1\') and press enter, otherwise type (\'0\').'
  another_git = STDIN.gets.to_i
  if another_git == 1
    puts 'Please enter another github url.'
    newurl = STDIN.gets.chomp
    system "git -C #{path} remote set-url --add --push origin #{giturl}"
    system "git -C #{path} remote set-url --add --push origin #{newurl}"
    system "git -C #{path} remote -v"
  end
  puts 'What kind of project is it?\n (\'1\') C\n (\'2\') Shell\n (\'3\') Ruby\n(\'4\') Other\n'
  proj_type = STDIN.gets.to_i
  if proj_type == 1
    tmp = '/tmp/make'
    if File.exists?(tmp)
      system "rm -rf #{tmp}"
    end
    system "git clone '#{makefile}' '#{tmp}'"
    system "cp #{tmp}/Makefile #{path}"
    puts 'Cool! Do you want to add libft? If so type (\'1\') and press enter, otherwise type (\'0\').'
    yesorno = STDIN.gets.to_i
    if yesorno == 1
      system "mkdir '#{path}/src'"
      system "git clone '#{libft}' '#{path}/src/lib/libft'"
      system "mkdir '#{path}/includes'"
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
    system "touch '#{path}/#{arg}.rb' && echo '#!/bin/sh\n # Insert stuff below' >> #{path}/#{arg}"
    gitpush(path)
  elsif proj_type == 3
    system "touch '#{path}/author' && echo $USER >> #{path}/author"
    system "touch '#{path}/#{arg}.sh' && echo '#!/usr/bin/env ruby\n # Insert stuff below' >> #{path}/#{arg}"
    gitpush(path)
  elsif proj_type == 4
    system "touch '#{path}/author' && echo $USER >> #{path}/author"
    gitpush(path)
  end
end


if ARGV.size < 1
  puts 'Too few arguments. Please include the name of the project as an argument'
  puts 'usage: ./proj_script.rb <project_name>'
  exit
elsif ARGV.size > 1
  puts 'Please enter only one project.'
  puts 'usage: ./proj_script.rb <project_name>'
  exit
else
  puts 'Alright lets see if this works'
  ARGV.each do |arg|
    path = File.expand_path("~/cadet/#{arg}")
    if File.exists? path
      puts 'File or Folder already exists'
      if Dir.entries(path).size <= 2
        puts 'File are in the folder you are trying to create. If you would like to remove them and continue with the git clone type (\'1\') otherwise, please run the script again and enter a project name that doesn\'t already exist.'
        removefiles = gets.to_i
        if removefiles == 1
          system 'rm -rf #{path}'
          nextpart(arg, path, makefile, libft)
        else
          puts 'The files were not removed, please run the script again.'
          exit
        end
      end
      puts 'If you would still like to git clone to the same directory type (\'1\'), otherwise type (\'0\') and run try running the script again'
    else
      nextpart(arg, path, makefile, libft)
    end
  end
end
