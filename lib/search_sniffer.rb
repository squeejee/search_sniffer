# Adapted from http://www.insiderpages.com/rubyonrails/2007/01/get-referring-search-engine-keywords.html

module Squeejee  #:nodoc:
  module SearchSniffer  #:nodoc:
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
    		#request.env["HTTP_REFERER"] = "http://www.google.com/search?q=ruby+on+rails+houston&ie=utf-8&oe=utf-8&aq=t&rls=org.mozilla:en-US:official&client=firefox-a"
        referer = request.env["HTTP_REFERER"]
        unless referer.blank?
          search_referers = [
            [/^http:\/\/(www\.)?google.*/, 'q'],
            [/^http:\/\/search\.yahoo.*/, 'p'],
            [/^http:\/\/search\.msn.*/, 'q'],
            [/^http:\/\/search\.aol.*/, 'userQuery'],
            [/^http:\/\/(www\.)?altavista.*/, 'q'],
            [/^http:\/\/(www\.)?feedster.*/, 'q'],
            [/^http:\/\/search\.lycos.*/, 'query'],
            [/^http:\/\/(www\.)?alltheweb.*/, 'q']
          ]
          query_args =
            begin
              URI.split(referer)[7]
            rescue URI::InvalidURIError
              nil
            end
          search_referers.each do |reg, query_param_name|
            # Check if the referrer is a search engine we are targetting
            if (reg.match(referer))

              # Highlight the Search Term Keywords on the page
              #@javascripts.push('keyword_highlighter')

              # Create a globally scoped variable (@referring_search) containing the referring Search Engine Query
              unless query_args.empty?
                query_args.split("&").each do |arg|
                  pieces = arg.split('=')
                  if pieces.length == 2 && pieces.first == query_param_name
                    unstopped_keywords = CGI.unescape(pieces.last)
                    stop_words = /\b(\d+|\w|about|after|also|an|and|are|as|at|be|because|before|between|but|by|can|com|de|do|en|for|from|has|how|however|htm|html|if|i|in|into|is|it|la|no|of|on|or|other|out|since|site|such|than|that|the|there|these|this|those|to|under|upon|vs|was|what|when|where|whether|which|who|will|with|within|without|www|you|your)\b/i
                    @referring_search = unstopped_keywords.gsub(stop_words, '').squeeze(' ')
                    logger.info("Referring Search Keywords: #{@referring_search}")
                    return true
                  end
                end
              end
              return true
            end
          end
        end
        true
      end
  end
end