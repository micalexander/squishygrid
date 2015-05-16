(function($){
  $(document).ready(function() {
    function uuid() {

      var d = new Date().getTime();
      var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c)
      {
          var r = (d + Math.random()*16)%16 | 0;
          d = Math.floor(d/16);
          return (c=='x' ? r : (r&0x7|0x8)).toString(16);
      });

      return uuid;
    }

    $('.output-toggle').each(function() {
      var sassUuid = uuid();
      var lessUuid = uuid();

      $($(this).find('h5 .toggle').get(0))
        .attr('data-uuid', sassUuid)
        .attr('data-type', 'sass')
        .addClass('selected');

      $($(this).find('h5 .toggle').get(1))
        .attr('data-uuid', lessUuid)
        .attr('data-type', 'less');

      $($(this).children('.code-output').get(0))
        .attr('data-uuid', sassUuid);

      $($(this).children('.code-output').get(1))
        .attr('data-uuid', lessUuid);

      $('.code-output[data-uuid="' + sassUuid + '"]')
        .addClass('selected');
    });

    $('.toggle').click(function() {
      $('.toggle[data-type="' + $(this).attr('data-type') + '"]').each(function() {

        var outputId = $(this).attr('data-uuid');

        $('.toggle[data-uuid="' + outputId + '"]')
          .addClass('selected')
          .siblings('.toggle')
          .removeClass('selected');

        $('.code-output[data-uuid="' + outputId + '"]')
          .addClass('selected')
          .siblings('.code-output')
          .removeClass('selected');
      });

      return false;
    });
  });
}(jQuery));