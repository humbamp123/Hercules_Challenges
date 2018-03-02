#!/usr/bin/env ruby

require 'open3'
require 'net/http'
require 'thread'

def wget web
  j = 0
  while j < 100
    command = "wget --show-progress --convert-links --random-wait -r -p -E -e robots=off -U mozilla -R index.html* #{web}"
    Thread.new do
      `#{command}`
    end
    sleep (0.1)
    j += 1
  end
end

def loadUrl web
  i = 0
  while i < 100
    Thread.new do
      wget web
      end
    i += 1
  end
end

loadUrl ARGV[0]
