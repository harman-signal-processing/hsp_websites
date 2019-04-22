jQuery(function() {

  var loadMore = function(url, callback) {
    $.ajax({
      url: url,
      dataType: "script"
    }).done(function() {
      if (typeof callback === 'function') { callback() }
    }).fail(function (jqxhr, settings, exception) {
      $('.infinite-pagination').html('Error!');
      console.log(exception);
    });
  };

  $(document).on('click', '.infinite-pagination a', function(e) {
    e.preventDefault();
    loadMore(e.target.href);
  });

  $(window).on('scroll', function() {
    if ($('.infinite-pagination').length <= 0) return;

    var more_posts_url = $('.infinite-pagination a.next_page').attr('href');
    var bottom_distance = 20;
    var fetching_more = false;

    if (more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - bottom_distance && !fetching_more) {
      fetching_more = true;
      $('.infinite-pagination').html('Loading...');
      loadMore(more_posts_url, function () {
        fetching_more = false;
      });
    }
  });
});
