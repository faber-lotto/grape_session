require 'rack'
require 'grape_session/version'
require 'active_support/concern'
require 'grape_cookies'

module GrapeSession
  require 'grape_session/configuration'
  require 'grape_session/ext/endpoint'
  require 'grape_session/ext/api'
end

require 'grape'
require 'grape/api'
require 'grape/endpoint'

Grape::Endpoint.send(:include, GrapeSession::Ext::Endpoint)
