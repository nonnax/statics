#!/usr/bin/env ruby
# Id$ nonnax 2022-04-07 22:45:23 +0800
D=Object.method(:define_method)
module Map
  extend self
  routes={}
  D.(:map){ routes }
  D.(:req){ @req }
  D.(:halt){ |r| throw :halt, r }
  D.(:get){|u, f=nil, &b|
    b ||= proc {f}
    routes[u]=b
  }
  def self.call(env)
    @req=Rack::Request.new(env)
    catch(:halt) do
      block=map.dup[env['PATH_INFO']] if env['REQUEST_METHOD']=='GET'
      f=File.join('public', instance_exec(req.params, &block))
      body = File.readlines(f, 'r').map if File.exist?(f)
      return [200, {'Content-type' => 'text/html'}, body] if body
      [404, {}, ['Not found']]
    end
  end
end
