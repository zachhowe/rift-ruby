#!/usr/bin/env ruby

require './lib/rift_client.rb'
include Rift

email = ARGV[0]
password = ARGV[1]
character_id = ARGV[2]
scratch_offs_to_do = eval(ARGV[3])

if !email.nil? && !password.nil?
  r = RiftClient.new
  r.auth(email, password)
  cards = r.cards

  availablePoints = cards['data']['availablePoints']
  secondsUntilNextPoint = cards['data']['secondsUntilNextPoint']

  puts "Available Points: #{availablePoints}"
  puts "Seconds Until Next Point: #{secondsUntilNextPoint}"
  puts

  scratch_offs = 1

  if !scratch_offs_to_do.nil?
    scratch_offs = [availablePoints, scratch_offs_to_do].min
  end

  if !character_id.nil?
    for i in 1 .. scratch_offs
      r.do_scatch_off_with_character character_id
    end
  else
    characters = r.characters

    puts "List of Characters"
    puts
    puts "Name:\t\tShard:\t\t\tCharacter ID:"
    puts

    characters.each do |ch|
      puts "#{ch.character_name}\t\t#{ch.shard}\t\t#{ch.character_id}"
    end
  end
else
  puts "usage: rift_scratch_offs.rb [email] [password] [character_id = 0] [scratch_offs_to_do = 1]"
  puts
  puts "note: if `character_id` is not specified, you will get a list of characters"
  puts "note: if `character_id` is specified but `scratch_offs_to_do` is not, only 1 scratch off will be done"
end
