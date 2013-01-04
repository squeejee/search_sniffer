require "search-sniffer/version"
require "search-sniffer/search-sniffer"


ActionController::Base.send(:include, Search::Sniffer::ControllerMethods)