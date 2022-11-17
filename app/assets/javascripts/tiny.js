tinyMCE.init({
  selector: 'textarea.mceEditor',
  browsers: "msie,gecko,safari",
  cleanup: false,
  cleanup_on_startup: false,
  convert_fonts_to_spans: true,
  convert_urls: false,
  entities: '160,nbsp,38,amp,34,quot,162,cent,8364,euro,163,pound,165,yen,169,copy,174,reg,8482,trade,8240,permil,60,lt,62,gt,8804,le,8805,ge,176,deg,8722,minus',
  entity_encoding: 'named',
  valid_elements: '+*[*]',
  language: 'en',
  mode: 'textareas',
  plugins: "advlist,anchor,autolink,autoresize,colorpicker,code,hr,image,link,lists,media,searchreplace,spellchecker,textcolor,table,paste,preview",
  relative_urls: false,
  verify_html: false
});
tinyMCE.init({
  selector: 'textarea.mceEditorFP',
  browsers: "msie,gecko,safari",
  cleanup: false,
  cleanup_on_startup: false,
  convert_fonts_to_spans: true,
  convert_urls: false,
  entities: '160,nbsp,38,amp,34,quot,162,cent,8364,euro,163,pound,165,yen,169,copy,174,reg,8482,trade,8240,permil,60,lt,62,gt,8804,le,8805,ge,176,deg,8722,minus',
  entity_encoding: 'named',
  valid_elements: '+*[*]',
  language: 'en',
  mode: 'textareas',
  plugins: "advlist,anchor,autolink,autoresize,colorpicker,code,hr,image,link,lists,media,searchreplace,spellchecker,textcolor,table,paste,preview,fullscreen",
  relative_urls: false,
  verify_html: false
});
