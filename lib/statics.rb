#!/usr/bin/env ruby
# Id$ nonnax 2022-04-07 22:45:23 +0800
D=Object.method(:define_method)
F=File
module Map
  routes={}
  D.(:map){ routes }
  D.(:file) do |f| F.join('public', f).then{|f| res.write(F.read(f)) if F.exist?(f) } end
  D.(:[]=){ |k, v| routes[k]=->(_){ file(v) }}
  D.(:req){ @req }
  D.(:res){ @res }
  D.(:halt){ |r| throw :halt, r }
  D.(:get){|u, f=nil, &b| b ||= ->(_){file(f)}; routes[u]=b  }
  def self.new
    @stack=Rack::Builder.new do   
      use Rack::Static, :root => 'public', :urls => ["/images", "/js", "/css"] 
      run App.new
    end
    @stack
  end
  class App
    def call(env)
      @req=Rack::Request.new(env)
      @res=Rack::Response.new
      res.headers['Content-type']='text/html; charset=utf-8'
      catch(:halt) {
        block=map.dup[env['PATH_INFO']] if env['REQUEST_METHOD']=='GET'
        instance_exec(req.params, &block) #rescue nil
        return res.finish unless res.body.empty?
        [404, {}, ['Not found']]
      }
      rescue Exception=>e
        [500, {}, [e.message]]
    end
  end
end


