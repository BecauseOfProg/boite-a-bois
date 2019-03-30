require 'mongocore'

Mongocore.schema = File.join(Dir.pwd, 'lib', 'db', 'schemas')
Mongo::Logger.logger.level = ::Logger::FATAL

require_relative 'models'

Mongocore.db = Mongo::Client.new(
  "mongodb://#{$config['database']['username']}:#{$config['database']['password']}@#{$config['database']['address']}:#{$config['database']['port']}/#{$config['database']['auth_source']}")