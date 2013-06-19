# Should not be needed after rails 4.0+
#
# Source: https://gist.github.com/loren/3380888
#
# This helps handle URLs with a bunch of bad encoding. The
# search engines have become notorious for crawling with
# URLs starting with %-encoded stuff that isn't even valid.
# Without this file, it goes through to the router and rails
# tries to parse it, ultimately ending in a 500 error and an
# error message in my inbox.
#
require 'action_dispatch/routing/route_set'

module ActionDispatch
	module Routing
		class RouteSet
			class Dispatcher
				def call_with_invalid_char_handling(env)
					uri = CGI::unescape(env["REQUEST_URI"].force_encoding("UTF-8"))
					# If anything in the REQUEST_URI has an invalid encoding, then raise since it's likely to trigger errors further on.
					return [400, {'X-Cascade' => 'pass'}, []] if uri.is_a?(String) and !uri.valid_encoding?
					call_without_invalid_char_handling(env)
				end
			 
			alias_method_chain :call, :invalid_char_handling
			end
		end
	end
end