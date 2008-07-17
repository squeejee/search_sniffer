# Adapted from http://www.insiderpages.com/rubyonrails/2007/01/get-referring-search-engine-keywords.html

module Squeejee  #:nodoc:
  module SearchSniffer  #:nodoc:
    module ControllerMethods
      #   Creates @referring_search containing any referring search engine query minus stop words
      #
      # eg. If the HTTP_REFERER header indicates page referer as:
      #     http://www.google.com/search?q=ruby+on+rails+houston&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a
      #   
      #     then this function will create:
      #     @referring_search = "Ruby Rails Houston"
      #   
      def sniff_referring_search
        # Check whether referring URL was a search engine result
        # uncomment out the line below to test
    		# request.env["HTTP_REFERER"] = "http://www.google.com/search?q=ruby+on+rails+houston&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a"
        referer = request.env["HTTP_REFERER"]
        rs = ReferringSearch.new(referer)
        @referring_search = rs.referring_search
        @referring_search_raw = rs.raw
        true
      end # sniff_referring_search
    end # Module Controller Methods
      
      
      class ReferringSearch
        
        attr_accessor :search_referers
        attr_accessor :stop_words
        
        attr_reader :referring_search
        attr_reader :raw
      
        def initialize(referer)
          # stop words is a variable
          # .raw .original as they typed to_s, including blacklisted stuff
          # .ref
          @search_referers = {
                :google     => [/^http:\/\/(www\.)?google.*/, 'q'],
                :yahoo      => [/^http:\/\/search\.yahoo.*/, 'p'],
                :msn        => [/^http:\/\/search\.msn.*/, 'q'],
                :aol        => [/^http:\/\/search\.aol.*/, 'userQuery'],
                :altavista  => [/^http:\/\/(www\.)?altavista.*/, 'q'],
                :feedster   => [/^http:\/\/(www\.)?feedster.*/, 'q'],
                :lycos      => [/^http:\/\/search\.lycos.*/, 'query'],
                :alltheweb  => [/^http:\/\/(www\.)?alltheweb.*/, 'q'] 
              }
              
          @stop_words = /\b(\d+|\w|about|after|also|an|and|are|as|at|be|because|before|between|but|by|can|com|de|do|en|for|from|has|how|however|htm|html|if|i|in|into|is|it|la|no|of|on|or|other|out|since|site|such|than|that|the|there|these|this|those|to|under|upon|vs|was|what|when|where|whether|which|who|will|with|within|without|www|you|your)\b/i
          
          # Get query args
          query_args =
            begin
              URI.split(referer)[7]
            rescue URI::InvalidURIError
              nil
            end
            
          # Determine the referring search that was used
          unless referer.blank?
            @search_referers.each do |k, v|
              reg, query_param_name = v
              # Check if the referrer is a search engine we are targetting
              if (reg.match(referer))

                # Highlight the Search Term Keywords on the page
                #@javascripts.push('keyword_highlighter')

                unless query_args.empty?
                  query_args.split("&").each do |arg|
                    pieces = arg.split('=')
                    if pieces.length == 2 && pieces.first == query_param_name
                      unstopped_keywords = CGI.unescape(pieces.last)
                      @raw = unstopped_keywords
                      @referring_search = unstopped_keywords.gsub(@stop_words, '').squeeze(' ')
                      #logger.info("Referring Search Keywords: #{referring_search}")
                      return true
                    end
                  end
                end # unless
                
                return true # because we found a match
              end # if
            end # do
          end #unless          
        end #initialize
        
        # Return the referring search string instead of the object serialized into a string
        def to_s
          return @referring_search
        end
        
      end # ReferringSearch
      
  end # Module SearchSniffer
end # Module Squeejee