require "active_support/core_ext/string/filters"
require "chronic_duration"
require "httparty"
require "nokogiri"
require "opendmm/utils"

module OpenDMM
  module Maker
    @@makers = []

    def self.included(mod)
      @@makers << mod
    end

    # Known fields:
    #
    # {
    #   actresses:     Hash
    #   actress_types: Array
    #   brand:         String
    #   code:          String
    #   description:   String
    #   directors:     Array
    #   genres:        Array
    #   images: {
    #     cover:   String
    #     samples: Array,
    #   },
    #   label:         String
    #   maker:         String
    #   movie_length:  String
    #   page:          String
    #   release_date:  String
    #   scenes:        Array
    #   series:        String
    #   title:         String
    # }

    def self.search(name)
      @@makers.each do |maker|
        result = maker.search(name)
        return result if result
      end
      nil
    end
  end
end

Dir[File.dirname(__FILE__) + '/makers/*.rb'].each do |file|
  require file
end
