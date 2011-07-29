# encoding: utf-8

module GoogleReader
end

class GoogleReaderError < ::Exception; end

require 'google_reader/login'
require 'google_reader/api'

