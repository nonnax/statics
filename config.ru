#!/usr/bin/env bash
# Id$ nonnax 2022-03-21 21:31:49 +0800
require_relative 'lib/statics'

use Rack::Static, 
  :urls => ["/images", "/js", "/css"],
  :root => 'public'

get('/') {
  'index.html'
}

get('/home') {
  'index.html'
}

get('/note') { |param|
  param['name'] ||= 'note'
  "#{param['name']}.html"
}

get('/red') {
  halt [302, {'Location'=>'/note'}, []]
}
get '/text',  'note.html'

p Map.map

run Map
