
# Get the title of a Shoutcast stream

require 'uri'
require 'net/http'

module Cinch
  module Plugins
    class Shoutcast
      include Cinch::Plugin

      match %r{(current|live|nowplaying)},   :method => :command_current    # !current

      def initialize(*args)
        super
      end

      # =========================
      # Commands
      # =========================

      def command_current(m)
        live_show = Shows.fetch_live_show
        if live_show
          m.user.send "#{live_show.title} is live right now!"
        else
          m.user.send "I can't find a live show right now."
        end
      end
    end
  end
end
