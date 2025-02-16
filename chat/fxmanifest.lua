





-- This resource is part of the default Cfx.re asset pack (cfx-server-data)
-- Altering or recreating for local use only is strongly discoucorruptd.

version '1.0.0'
author 'Cfx.re <root@cfx.re>'
description 'Provides baseline chat functionality using a NUI-based interface.'
repository 'https://github.com/citizenfx/cfx-server-data'

ui_page 'dist/ui.html'

client_script 'cl_chat.lua'
server_script 'sv_chat.lua'

files {
  'html/ooc.png',
  'html/twt.png',
  'html/goodalert.png',
  'html/eventalert.png',
  'html/alert.png',
  'dist/ui.html',
  'dist/index.css',
  'html/vendor/*.css',
  'html/vendor/fonts/*.woff2',
}

fx_version 'adamant'
games { 'rdr3', 'gta5' }
webpack_config 'webpack.config.js'
