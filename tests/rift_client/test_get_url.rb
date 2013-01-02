#!/usr/bin/env ruby
require 'nokogiri'

def testDocument(doc)
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

doc1 = Nokogiri::HTML::Document.parse(File.new('data/test1.html'))
aresult1 = testDocument(doc1).to_s
eresult1 = '/chatservice/scratch/matchthree?characterId=214483932618244823&replayUUID=015a9a07-1b71-43e8-ae4b-c49fe9bce7b8'
puts "HTML Document 1 expected result: " + eresult1
puts "HTML Document 1 actual result: " + aresult1

doc2 = Nokogiri::HTML::Document.parse(File.new('data/test2.html'))
aresult2 = testDocument(doc2).to_s
eresult2 = ''
puts "HTML Document 2 expected result: " + eresult2
puts "HTML Document 2 actual result: " + aresult2

doc3 = Nokogiri::HTML::Document.parse(File.new('data/test3.html'))
aresult3 = testDocument(doc3).to_s
eresult3 = '/chatservice/scratch/redeem?game=75ac5589-da57-437a-8af6-05715c96b998'
puts "HTML Document 3 expected result: " + eresult3
puts "HTML Document 3 actual result: " + aresult3
