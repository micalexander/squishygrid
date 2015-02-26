(function($){
  $(document).ready(function() {
    var htmlClient = new ZeroClipboard( document.getElementById("html-copy-button") );

    htmlClient.on( "ready", function( readyEvent ) {

      // alert( "ZeroClipboard SWF is ready!" );
      htmlClient.on( "aftercopy", function( event ) {
        // `this` === `client`
        // `event.target` === the element that was clicked
        // event.target.style.display = "none";
        $('#html-copy-button')
          .velocity({ top: "5" }, 50)
          .velocity({ top: "0" }, {
            duration: 800,
            easing: [ 500, 8 ]
          })
          .text('Copied')
          .removeClass('fa-clipboard')
          .addClass('fa-check')
          .toggleClass('copied');
        setTimeout(function() {
          $('#html-copy-button')
            .text('Copy to Clipboard')
            .removeClass('fa-check')
            .addClass('fa-clipboard')
            .toggleClass('copied');
        }, 500);
      });
    });

    var stylesClient = new ZeroClipboard( document.getElementById("styles-copy-button") );

    stylesClient.on( "ready", function( readyEvent ) {

      // alert( "ZeroClipboard SWF is ready!" );
      stylesClient.on( "aftercopy", function( event ) {
        // `this` === `client`
        // `event.target` === the element that was clicked
        // event.target.style.display = "none";
        $('#styles-copy-button')
          .velocity({ top: "5" }, 50)
          .velocity({ top: "0" }, {
            duration: 800,
            easing: [ 500, 8 ]
          })
          .text('Copied')
          .removeClass('fa-clipboard')
          .addClass('fa-check')
          .toggleClass('copied');
        setTimeout(function() {
          $('#styles-copy-button')
            .text('Copy to Clipboard')
            .removeClass('fa-check')
            .addClass('fa-clipboard')
            .toggleClass('copied');
        }, 500);
      });
    });
  });
}(jQuery));