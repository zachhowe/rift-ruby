require 'net/http'

module Rift
  class RiftRequest
    attr_accessor :use_proxy, :proxy

    def initialize(url_string)
    end

    def get
    end

    def post(form_data)
    end
  end
end