require 'discordrb'
require_relative 'core'
require 'json'

config_file = File.dirname(__FILE__) + '/config.json'
roles_file = File.dirname(__FILE__) + '/roles.json'

if File::exist?(config_file) && File::exist?(roles_file)

  json = JSON.parse(File.read(config_file))

  if json['debug']
    debug = :debug
  else
    debug = :normal
  end
  bot = Discordrb::Bot.new token: json['token'], client_id: json['client_id'], log_mode: debug, ignore_bots: true

  bot.ready do
    $core = BecauseOfBot::Core.new bot
  end

  bot.message do |event|
    msg = event.content
    if $core == nil
      $core = BecauseOfBot::Core.new bot
    end
    prefix = $core.config('prefix')
    regex = '^' + Regexp.escape(prefix) + '([a-zA-Z]+)( (.+)?)?'
    regex = Regexp.new regex
    resp = regex.match(msg)
    args = []
    if resp != nil
      cmd = resp[1]
      args = resp[3].split(' ') if resp[3] != nil
      $core.onCommand(cmd, args, event)
    end
  end

  bot.run

else
  puts 'Config file needed'
end
