jQuery(function() {
  if ($('.infinite-pagination').size() > 0) {
    $(window).on('scroll', function() {
      var more_posts_url = $('.infinite-pagination a.next_page').attr('href');
      var bottom_distance = 20;

      if (more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - bottom_distance) {
        $('.infinite-pagination').html('Loading more...');
        $.getScript(more_posts_url);
      }
    });
  }
});
