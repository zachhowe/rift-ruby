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
end

doc1 = Nokogiri::HTML::Document.parse(File.new('data/test1.html'))
puts "HTML Document 1 result: " + testDocument(doc1).to_s

doc2 = Nokogiri::HTML::Document.parse(File.new('data/test2.html'))
puts "HTML Document 2 result: " + testDocument(doc2).to_s

doc3 = Nokogiri::HTML::Document.parse(File.new('data/test3.html'))
puts "HTML Document 3 result: " + testDocument(doc3).to_s
