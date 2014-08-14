require 'rack'
require 'grape_session/version'
require 'active_support/concern'

module GrapeSession
  require 'grape_session/configuration'
  require 'grape_session/dsl/configuration'
  require 'grape_session/middleware/env_setup'
  require 'grape_session/ext/endpoint'
  require 'grape_session/ext/request'
  require 'grape_session/ext/api'
  require 'grape_session/ext/cookie_jar'
end

require 'grape'
require 'grape/api'
require 'grape/endpoint'

Grape::Endpoint.send(:include, GrapeSession::Ext::Endpoint)
Grape::Request.send(:include, GrapeSession::Ext::Request)
# Grape::API.send(:include, GrapeSession::Ext::API)

unless ActionDispatch::Cookies::CookieJar.instance_methods.include? :read
  ActionDispatch::Cookies::CookieJar.send(:include, GrapeSession::Ext::CookieJar)
end
