#!/usr/bin/env bash
# Id$ nonnax 2022-03-21 21:31:49 +0800
require_relative 'lib/statics'
require 'yaml'


get("/") {
  res.write 'honey, im home!'
}

get("/home") {
  file 'index.html'
}

get("/note") { |param|
  param['name'] ||= 'note'
  file "#{param['name']}.html"
}

get("/red") {
  halt [302, {'Location'=>'/note'}, []]
}

get '/text',  'note.html'

Map['/hq']='index.html'
Map['/bahay']='kubo.html'

puts Map.map.to_yaml

run Map.new
