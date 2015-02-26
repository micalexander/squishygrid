(function($){
  $(document).ready(function() {

    // toggle gridpreview margin
    $('#grid_type').change(function() {
      $('.preview .grid').toggleClass('compact');
    });
  });
}(jQuery));