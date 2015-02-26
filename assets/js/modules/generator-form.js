(function($){
  $(document).ready(function() {
    if ($( "#output option:selected" ).text().trim() == 'CSS') {
      $('#mixin').prop("disabled", true);
      $('#mixin').closest('.mixin').css({'opacity': .4});
    }
    $( "#output" ).change(function() {
      if ($( "#output option:selected" ).text().trim() == 'CSS') {
        $('#mixin').prop("disabled", true);
        $('#mixin').closest('.mixin').css({'opacity': .4});
      }
      else {
        $('#mixin').prop("disabled", false);
        $('#mixin').closest('.mixin').css({'opacity': 1});
      }
    });
  });
}(jQuery));