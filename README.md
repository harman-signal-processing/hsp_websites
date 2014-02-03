HSP Brand Websites
===================

A nifty rails application used for hosting several websites for HARMAN Signal Processing brands. In theory, this framework could be used to build a site for any company that makes products. Doing so would require customzing the CSS and HTML templates (undocumented). Features include:

* Homepage with feature slideshow, social feeds, etc.
* Product catalog (organized by product families)
* Product attachments (manuals, photos, etc.)
* News articles with RSS feed
* Promotions
* Artists (notable people who use your products)
* Product registration
* Find a dealer with mapped results (US)
* Find a distributor (non-US)
* Buy-it-now links to online retailers
* Support/Contact Us
* Software downloads section with simple counter
* I18n (content translation). Bing auto-translation with manual adjustment if needed.
* Site search using thinking_sphinx
* Administrative interface for all of that stuff above.

Secondary Sites
===============

In addition to the brand websites described above, some secondary sites are included...

Job Queue
---------

Integrated with the brand sites is a job queue. Market managers for the brands enter jobs which are assigned and worked-on by graphic designers, copy writers, webmaster, etc. 

Marketing Toolkit
-----------------

Brands and their products can be setup to appear on the included Marketing Toolkit which provides key high-res assets to distributors and other media personnel.

User Access
===========

Users for administration, job queue, marketing toolkits and artists section are managed with Devise and CanCan.
