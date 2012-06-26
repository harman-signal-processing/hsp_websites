# These redirects from the old sites to this rails app are loaded
# by the Rails3 router in config/routes.rb
# They're here to make the routes.rb less messy. Note: if the redirect-to value
# below (2nd value) starts with http, then the router will simply redirect to 
# that value. Otherwise, the router prepends the default I18n locale to the value
# below and then redirects to that.
DIGITECH_REDIRECTS = {
  '/Review_pdfs/Digitech JamMan review.pdf' => '/product_reviews/digitech-jamman-delay-looper-phaser-sampler',
  '/Review_pdfs/Digitech%20JamMan%20review.pdf' => '/product_reviews/digitech-jamman-delay-looper-phaser-sampler'
}
# moved to nginx config for speed...
HARDWIRE_REDIRECTS = {}
VOCALIST_REDIRECTS = {} 
DBX_REDIRECTS = {} 
LEXICON_REDIRECTS = {}
BSS_REDIRECTS = {}