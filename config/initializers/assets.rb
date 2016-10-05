# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )

# Add fonts to asset pipeline
Rails.application.config.assets.paths << Rails.root.join('app', 'assets', 'fonts')

Rails.application.config.assets.precompile += %w( .svg .eot .woff .ttf .jpg .png .gif )

Rails.application.config.assets.precompile += %w( lightbox/*
    vendor/custom.modernizr.js
    hiqnet.css
    hiqnet.js
    performancemanager.css
    performancemanager.js
    introducing_epedal.css
    introducing_stompbox.css
    istomp.css
    admin.js
    admin.css
    archimedia.css
    audio-architect.css
    amx.js
    amx.css
    bss.js
    bss.css
    crown.css
    crown.js
    soundcraft.css
    soundcraft.js
    dbx.css
    dbx.js
    digitech.css
    digitech.js
    dod.css
    dod.js
    jbl_commercial.css
    jbl_commercial.js
    lexicon.css
    lexicon.js
    idx.css
    site.css
    toolkit.css
    toolkit_application.js
    teaser_application.js
    dod_teaser.css
    studer.css
    studer.js
    akg.css
    akg.js
    duran.css
    duran.js
    jbl_professional.css
    jbl_professional.js
    )
