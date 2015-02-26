function coreScreenSize() {
  /* Media Queries for determining javascript events, via http://adactio.com/journal/5429/ */

  var body       = document.querySelector('body');
  var size = getComputedStyle(body,':after').content;

  if (size == 'mobile') {
    // console.log('mobile');
  }
  else if (size == 'tablet') {
    // console.log('tablet');
  }
  else if (size == 'desktop') {
    // console.log('desktop');
  };
}

$(window).resize(function() {

  coreScreenSize();
});

$(document).ready(function() {

  coreScreenSize();

  // create scroll link
  $(".core-scroll-link").click(function() {
    var link = $($(this).attr('href'));
    var divToScroll  = $(link['selector'].replace('#', '.'));
    divToScroll
      .velocity("scroll", 1000);

    return false
  });
});
