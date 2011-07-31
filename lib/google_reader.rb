# encoding: utf-8

module GoogleReader
end

class GoogleReaderError < ::Exception; end

require 'google_reader/api'
require 'google_reader/feed'
require 'google_reader/item'
require 'google_reader/subscription'

