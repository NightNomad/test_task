#!/usr/bin/env ruby

require 'slop'
require 'mechanize'
require 'json'

opts = Slop.parse do |o|
  o.string '--url', 'an URL for catalog'
  o.string '--filename', 'CSV filename'
end

agent = Mechanize.new
page = agent.get(opts[:url])

links_list = page.links_with(href: /Hills/, text: 'View Details')

list = []

links_list.map do |l|
  base = l.click
  name = base.css('#product_family_heading').text
  weight = base.css('.title').text.delete("\t").split("\n").delete_if(&:empty?)
  delivery = base.css('.in-stock').text.delete("\n\t")
  price = base.css('.ours').text.delete("\t" '/Our Offer price:').split(' ')
  id = base.css('.item-code').text.delete("\t" '/Quick Find:/').split(' ')
  list.push(
    name: (weight.map { |w| w = name + ", #{w}" }).join(', '),
    id: id.delete_if(&:empty?).join(', '),
    delivery: delivery,
    price: price.delete_if(&:empty?).join(', ')
  )
end

data = JSON.pretty_generate(list)
File.open("#{opts[:filename]}.json", 'w') { |f| f.write(data) }
