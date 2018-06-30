#!/usr/bin/env ruby
#scatter is a wrapper for setting up netcat tcp relays with source port manipulation
#version 0.1 - Codeine flavoured fever dream

require 'trollop'
require 'colorize'
require 'logger'
require 'tty-command'
require 'tty-prompt'
require 'pp'

def command
  log = Logger.new('debug.log')
  cmd = TTY::Command.new(printer: :pretty, output: log, pty: true)
end

def mappings_file
  tooldir  = File.expand_path(File.dirname(__FILE__))
  map_file = "#{tooldir}/mappings.txt"
  mappings = File.readlines(map_file)
end

def create_ncats
  puts "Want to give birth to some fresh ncats? y/n"
  if gets.chomp.downcase == "y"
    puts "Creating Fresh Cats...meow meow meow".green.bold
    mappings_file.each do |mapping|
      out, err = command.run!("sudo ncat -k -l -p #{mapping.split(":")[0]} -c 'ncat #{mapping.split(":")[1]} #{mapping.split(":")[2]} -p #{mapping.split(":")[3]}'", timeout: 1)
      if err =~ /Address already in use/
        print err.red.bold
      end
    end
  else
    puts "Exiting".green.bold
  end
  puts "Remaining Kitty Cats:".light_blue
  puts existing_ncats
end

def existing_ncats
  final = []
  out, err = command.run!("ps -af | grep 'ncat -k -l -p'", timeout: 1)
  process_array = out.split("\n").keep_if { |ele| ele =~ /sudo ncat -k -l -p \d+/ }
  process_array.each { |process| final << process.split(" ")[7..-1].join(" ")}
  final
end

def do_you_wanna_kill_an_ncat
  unless existing_ncats.empty?
    puts "Existing ncats detected!".light_blue
    puts existing_ncats
    puts "You already have some ncats...meow...want to kill some? y/n".red
    if gets.chomp.downcase == "y"
      select_ncats_for_execution
    end
  end
end

def select_ncats_for_execution
  prompt  = TTY::Prompt.new
  @choices = prompt.multi_select("Which cats would you like to murder?", existing_ncats, per_page: 20, echo: false)
  execute_ncats
end

def execute_ncats
  puts "Drowning ncats....Mew :(".cyan.bold
  @choices.each do |choice|
    out, err = command.run!("sudo pkill -f '#{choice}'")
  end
end

do_you_wanna_kill_an_ncat
create_ncats
