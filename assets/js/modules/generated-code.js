(function($){
  $(window).load(function() {
    // on pageload get default grid
    $.ajax({
      type: "POST",
      url: "/generator",
      data: $('form#get-grid').serialize(),
      dataType: 'json',
      success: function(value){
        $(".rendered.html").hide();
        $(".rendered.styles").hide();
        $(".rendered.html .container").html(value.html)
        $(".rendered.styles .container").html(value.styles)
        $("#html-copy-button").attr('data-clipboard-text',value.html_text)
        $("#styles-copy-button").attr('data-clipboard-text',value.styles_text)
        $(".rendered.html").velocity('transition.expandIn',  200);
        $(".rendered.styles").velocity('transition.expandIn',  200);
      },
      error: function(){
        $(".rendered.html .container").html('Load unseccessful')
        $(".rendered.styles .container").html('Load unseccessful')
      }
    });

    // on click get grid
    $("form#get-grid").submit(function(){

      $(".rendered.html .container").html('<div class="loader"></div>')
      $(".rendered.styles .container").html('<div class="loader"></div>')

      $.ajax({
        type: "POST",
        url: "/generator",
        data: $('form#get-grid').serialize(),
        dataType: 'json',
        success: function(value){
          $(".rendered.html").hide();
          $(".rendered.styles").hide();
          $(".rendered.html .container").html(value.html)
          $(".rendered.styles .container").html(value.styles)
          $("#html-copy-button").attr('data-clipboard-text',value.html_text)
          $("#styles-copy-button").attr('data-clipboard-text',value.styles_text)
          $(".rendered.html").velocity('transition.expandIn',  200);
          $(".rendered.styles").velocity('transition.expandIn',  200);
        },
        error: function(e){
          $(".rendered.html .container").html('Load unseccessful')
          $(".rendered.styles .container").html('Load unseccessful')
        }
      });

      return false;
    });
  });
}(jQuery));