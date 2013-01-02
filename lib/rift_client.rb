require 'net/http'
require 'uuid'
require 'json/ext'
require 'nokogiri'

require_relative 'rift_request'
require_relative 'rift_character'

module Rift
  class RiftClient
    attr_accessor :ticket, :session_id

    def initialize
      @proxify = Net::HTTP::Proxy('127.0.0.1', 8888)
    end

    def auth(email, password)
      uri = URI('https://auth.trionworlds.com/auth')

      @proxify.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
        request = Net::HTTP::Post.new(uri.request_uri)
        request.add_field('Host', 'auth.trionworlds.com')
        request.set_form_data('username' => email, 'password' => password, 'channel' => 1)
        response = http.request request

        self.ticket = response.body
      end

      login
    end

    def login
      uri = URI('https://chat-us.riftgame.com/chatservice/loginByTicket?os=iOS&osVersion=5.100000&vendor=Apple')

      uuid = UUID.new
      self.session_id = uuid.generate

      @proxify.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
        request = Net::HTTP::Post.new(uri.request_uri)
        request.add_field('Cookie', "SESSIONID=#{self.session_id}")
        request.set_form_data('ticket' => self.ticket)

        response = http.request request

        cookie = response['Set-Cookie']

        if cookie != ''
          cookie = cookie.split('=')[1]
          self.session_id = cookie.split(';')[0]
        end
      end
    end

    def characters
      uri = URI('http://chat-us.riftgame.com:8080/chatservice/chat/characters')

      @proxify.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
        request = Net::HTTP::Post.new(uri.request_uri)
        request.add_field('Cookie', "SESSIONID=#{self.session_id}")

        response = http.request request

        json = JSON::Ext::Parser.new(response.body)
        json_data = json.parse()

        chars = json_data['data']

        chr = Array.new

        chars.each do |ch|
          rc = RiftCharacter.new
          rc.character_id = ch['playerId']
          rc.character_name = ch['name']
          rc.shard = ch['shardName']

          chr << rc
        end

        return chr
      end
    end

    def cards
      uri = URI('http://chat-us.riftgame.com:8080/chatservice/scratch/cards')

      @proxify.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
        request = Net::HTTP::Post.new(uri.request_uri)
        request.add_field('Cookie', "SESSIONID=#{self.session_id}")

        response = http.request request

        json = JSON::Ext::Parser.new(response.body)
        json_data = json.parse()

        return json_data
      end
    end

    def do_scatch_off_with_character(character_id)
      do_scatch_off("/chatservice/scratch/matchthree?characterId=#{character_id}")
    end

    private

    def do_scatch_off(url_string)
      uri = URI("http://chat-us.riftgame.com:8080/" + url_string)

      @proxify.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
        request = Net::HTTP::Get.new(uri.request_uri)
        request.add_field('Cookie', "SESSIONID=#{self.session_id}")

        response = http.request request

        url = get_redeem_url(response.body)

        if !url.nil?
          if url.index('replayUUID').nil?
            puts "Claiming your rewards!"
            redeem(url)
          else
            puts "Replaying!"
            do_scatch_off(url)
          end
        else
          puts "You won nothing. Sorry..."
        end
      end
    end

    def redeem(url)
      uri = URI('http://chat-us.riftgame.com:8080/' + url)

      @proxify.start(uri.host, uri.port, :use_ssl => uri.scheme == 'https', :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
        request = Net::HTTP::Get.new(uri.request_uri)
        request.add_field('Cookie', "SESSIONID=#{self.session_id}")

        response = http.request request

        # json = JSON::Ext::Parser.new(response.body)
        # json_data = json.parse()
        
        puts response.body
      end
    end

    def get_redeem_url(html_doc)
      doc = Nokogiri::HTML::Document.parse(html_doc)

      e = doc.xpath('//div[@id="reward-layer"]')
      e.each do |d|
        as = d.xpath('//a')
        as.each do |a|
          url = a['href']

          if url != '#'
            return url
          end
        end
      end

      nil
    end
  end
end
