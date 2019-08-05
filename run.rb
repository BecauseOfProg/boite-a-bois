require 'discordrb'
require 'openweathermap'
require 'json'

config_file = File.dirname(__FILE__) + '/config.json'

raise StandardError, 'The configuration file is needed at the root of the project.' unless File::exist?(config_file)

$config = JSON.parse(File.read(config_file))

require_relative 'core'

bot = Discordrb::Bot.new(token: $config['token'], 
                         client_id: $config['client_id'], 
                         log_mode: $config['debug'] ? :debug : :normal, 
                         ignore_bots: true)

bot.ready {
  $core = BoiteABois::Core.new(bot)
  bot.game = "#{$config['prefix']}help"
}

bot.message do |event|
  msg = event.content
  if $core == nil
    $core = BoiteABois::Core.new(bot)
  end
  prefix = $config['prefix']
  regex = '^' + Regexp.escape(prefix) + '([a-zA-Z]+)( (.+)?)?'
  regex = Regexp.new(regex)
  resp = regex.match(msg)
  args = []
  if resp != nil
    cmd = resp[1]
    args = resp[3].split(' ') if resp[3] != nil
    $core.on_command(cmd, args, event)
  end
end

bot.run
