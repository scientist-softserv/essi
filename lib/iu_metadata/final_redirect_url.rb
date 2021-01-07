# Adapted from https://github.com/indyarocks/final_redirect_url

# The MIT License (MIT)
#
# Copyright (c) 2017 Chandan Kumar
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'net/http'
require 'logger'

module IuMetadata
  class FinalRedirectUrl

  def self.final_redirect_url(url, options={})
    final_url = ''
    if is_valid_url?(url)
      begin
        redirect_lookup_depth = options[:depth].to_i > 0 ? options[:depth].to_i : 10
        response_uri = head_final_redirect_url(url, redirect_lookup_depth)
        # final_url =  url_string_from_uri(response_uri) # Don't use string constructor from upstream
        final_url = URI(response_uri).to_s
      rescue Exception => ex
        logger = Logger.new(STDOUT)
        logger.error(ex.message)
      end
    end
    final_url
  end

  private
    def self.is_valid_url?(url)
      url.to_s =~ /\A#{URI::regexp(['http', 'https'])}\z/
    end

    def self.head_final_redirect_url(url, limit = 10)
      return url if limit <= 0
      uri = URI.parse(url)
      response = Faraday.head(uri)
      if response.success?
        return uri
      else
        redirect_location = response.headers['location']
        location_uri = URI.parse(redirect_location)
        if location_uri.host.nil?
          redirect_location = uri.scheme + '://' + uri.host + redirect_location
        end
        warn "redirected to #{redirect_location}"
        head_final_redirect_url(redirect_location, limit - 1)
      end
    end

    def self.url_string_from_uri(uri)
      url_str = "#{uri.scheme}://#{uri.host}#{uri.request_uri}"
      if uri.fragment
        url_str = url_str + "##{uri.fragment}"
      end
      url_str
    end
  end
end
