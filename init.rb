require 'search_sniffer'
ActionController::Base.send(:include, Squeejee::SearchSniffer::ControllerMethods)