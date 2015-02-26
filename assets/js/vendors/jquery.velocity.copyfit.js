(function($){
  'use strict';

   //copyfit: Object Instance
  $.copyfit = function($el, options)
  {
    var copy = $el;

    // making variables public
    copy.vars       = $.extend({}, $.copyfit.defaults, options);

    var namespace      = copy.vars.namespace,
        copyfitSelector = $el,
        key             = copy.vars.keySelector,
        keys            = $(copyfitSelector).children(key),
        value           = copy.vars.valueSelector,
        values          = $(copyfitSelector).children(value),
        styles          = ['accordion', 'tabbed', 'slide', 'fade'],
        transitions     = ['fadeIn',
                           'fadeOut',
                           'flipXIn',
                           'flipXOut',
                           'flipYIn',
                           'flipYOut',
                           'flipBounceXIn',
                           'flipBounceXOut',
                           'flipBounceYIn',
                           'flipBounceYOut',
                           'swoopIn',
                           'swoopOut',
                           'whirlIn',
                           'whirlOut',
                           'shrinkIn',
                           'shrinkOut',
                           'expandIn',
                           'expandOut',
                           'bounceIn',
                           'bounceOut',
                           'bounceUpIn',
                           'bounceUpOut',
                           'bounceDownIn',
                           'bounceDownOut',
                           'bounceLeftIn',
                           'bounceLeftOut',
                           'bounceRightIn',
                           'bounceRightOut',
                           'slideUpIn',
                           'slideUpOut',
                           'slideDownIn',
                           'slideDownOut',
                           'slideLeftIn',
                           'slideLeftOut',
                           'slideRightIn',
                           'slideRightOut',
                           'slideUpBigIn',
                           'slideUpBigOut',
                           'slideDownBigIn',
                           'slideDownBigOut',
                           'slideLeftBigIn',
                           'slideLeftBigOut',
                           'slideRightBigIn',
                           'slideRightBigOut',
                           'perspectiveUpIn',
                           'perspectiveUpOut',
                           'perspectiveDownIn',
                           'perspectiveDownOut',
                           'perspectiveLeftIn',
                           'perspectiveLeftOut',
                           'perspectiveRightIn',
                           'perspectiveRightOut'],
        animationSpeed = copy.vars.animationSpeed,
        transitionIn   = $.inArray(copy.vars.transitionsIn, transitions) !== -1 ? 'transition.' + copy.vars.transitionsIn : '',
        transitionOut  = $.inArray(copy.vars.transitionsOut, transitions) !== -1 ? 'transition.' + copy.vars.transitionsOut : '',
        methods        = {};

    // Store a reference to the copy object
    $.data($($el), "copyfit", copy);

    methods = {
      init: function()
      {
        $($el).addClass(copy.vars.style);

        $(keys).each(function () {
          var uuid = methods.generateUUID();
          $(this).attr('data-' + namespace + 'key', uuid);
          $(this).next(values).attr('data-' + namespace + 'value', uuid);
        });

        // if copyfit style is allowed the run it
        if($.inArray(copy.vars.style, styles) !== -1) {
            this[copy.vars.style]();
        }

      },

      generateUUID: function() {

          var d = new Date().getTime();
          var uuid = 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, function(c)
          {
              var r = (d + Math.random()*16)%16 | 0;
              d = Math.floor(d/16);
              return (c=='x' ? r : (r&0x7|0x8)).toString(16);
          });

          return uuid;
      },

      accordion: function()
      {
        $(values).hide();

        $(keys).click(function(){

          var thisKey            = $(this),
              thisValue          = $('[data-' + namespace + 'value="' + $(this).attr('data-' + namespace + 'key') + '"]'),
              thisKeySpectator   = $(thisKey).siblings(key),
              thisValueSpectator = $(thisValue).siblings(value),
              clicks             = $(thisKey).data('clicks');

          if (!clicks)
          {
            $(thisKey)
              .siblings(value)
              .find(key + ' namespace + .selected')
              .click();

            // add the namespace +  selected class
            $(thisKey)
              .addClass( namespace + 'selected');
            $(thisValue)
              .addClass( namespace + 'selected');

            // remove the namespace +  selected class
            $(thisKeySpectator)
              .removeClass( namespace + 'selected');
            $(thisValueSpectator)
              .removeClass( namespace + 'selected');

            // handle slide animation
            $(thisValueSpectator)
              .velocity('slideUp',  animationSpeed);
            $(thisValue)
              .velocity('slideDown', animationSpeed);

            // tell accordion that these are not clicked anymore
            $(thisKeySpectator)
              .removeData('clicks');

          }
          else
          {
            $(thisValue)
              .find(key + ' namespace + .selected')
              .click();

            // remove the namespace +  selected class
            $(thisKey)
              .removeClass( namespace + 'selected');
            $(thisValue)
              .removeClass( namespace + 'selected');

            // tell accordion that these are not clicked anymore
            $(thisKey)
              .removeData('clicks', animationSpeed);

            // handle slide animation
            $(thisValue)
              .velocity('slideUp', animationSpeed);
          }
          $(thisKey)
          	.data("clicks", !clicks);
        });
      },

      tabbed: function()
      {
				var keyWidth   = copy.vars.keyWidth,
          	 valueWidth = copy.vars.valueWidth;

        $(copyfitSelector).each(function()
			 {
          var wrapper = $(this);

          var childrenKeys = $($(this).find(key).get(0))
          		.siblings(key)
          		.andSelf();

          var childrenValues = $($(this).find(value).get(0))
          		.siblings(value)
          		.andSelf();

          var keyHolder = '<div class="' + namespace + 'keys"></div>',
          	  valueHolder = '<div class="' + namespace + 'values"></div>';

          $(valueHolder).prependTo(wrapper);
          $(keyHolder).prependTo(wrapper);

          $(childrenKeys.get().reverse())
          	.each(function() {

            $(this)
            	.prependTo($(wrapper).children('.' + namespace + 'keys'));
          });

          $(childrenValues.get().reverse())
          	.each(function() {

            $(this)
            	.prependTo($(wrapper).children('.' + namespace + 'values'));
          });


          var activeKey   = $($(this).find(key).get(0)),
              activeValue = $($(this).find(value).get(0));

          activeValue
          	.addClass( namespace + 'selected');
          activeKey
          	.addClass( namespace + 'selected');

          $(values)
          	.hide();

          activeValue
          	.velocity(transitionIn,  animationSpeed);

        });

			$(keys).on('click', function()
       {
          var thisKey            = $(this),
              thisValue          = $('[data-' + namespace + 'value="' + $(this).attr('data-' + namespace + 'key') + '"]'),
              thisKeySpectator   = $(thisKey).siblings(key),
              thisValueSpectator = $(thisValue).siblings(value);

          // add the namespace +  selected class
          $(thisKey)
            .addClass( namespace + 'selected');
          $(thisValue)
            .addClass( namespace + 'selected');

          // remove the namespace +  selected class
          $(thisKeySpectator)
            .removeClass( namespace + 'selected');
          $(thisValueSpectator)
            .removeClass( namespace + 'selected');
        	  $(thisValueSpectator)
              .velocity(transitionOut,  animationSpeed, function() {

              if ($(this).parents(value).length > 0) {
                $(thisValue)
                    .parents($el)
                    .velocity({'min-height': $(thisValue).outerHeight()}, function() {
                  $(thisValue)
                    .velocity(transitionIn, animationSpeed);
                });

              }
              else
              {
                $(thisValue)
                  .velocity(transitionIn, animationSpeed);
              }
            });
        });

       function applyKeyPosition() {

          switch(copy.vars.position)
          {
            case 'left':
                var position = {
                  'keys': {
                    'float': 'left',
                    'width': keyWidth,
                  },
                  'values': {
                    'float': 'left',
                    'width': valueWidth,
                  },
                }
              break;
            case 'right':
                var position = {
                  'keys': {
                    'float': 'right',
                    'width': keyWidth,
                  },
                  'values': {
                    'float': 'right',
                    'width': valueWidth,
                  },
                }
              break;
            case 'top':
                var position = {
                  'key': {
                    'display': 'inline-block'
                  },
                }
              break;
            case 'stacked':

              break;
          }

          if (!$.isEmptyObject(position))
          {
            if (!$.isEmptyObject(position.keys))
            {
              $('.' + namespace + 'keys')
                .css(position.keys);
            }
            if (!$.isEmptyObject(position.values))
            {
              $('.' + namespace + 'values')
                .css(position.values);
            }
            if (!$.isEmptyObject(position.key))
            {
              $(copy.vars.keySelector)
                .css(position.key);
            }
          }
       }

       applyKeyPosition();

			$(window).resize(function()
       {

        	if ($(this).width() < copy.vars.breakpoint)
          {
              var position = {
                'keys': {
                  'float': '',
                  'width': '',
                },
                'values': {
                  'float': '',
                  'width': '',
                },
                'key': {
                  'display': ''
                },
              }
            $('.' + namespace + 'keys')
              .css(position.keys);
            $('.' + namespace + 'values')
              .css(position.values);
            $(copy.vars.keySelector)
              .css(position.key);
          }
        	else
          {
            applyKeyPosition();
          }

        });
      }

    };

    methods.init();
  };

  $.copyfit.defaults = {

    namespace     : 'copy-',
    style			  : 'tabbed',
    keySelector   : 'dt',
    valueSelector : 'dd',
    transitionsIn : 'slideUpIn',
    transitionsOut: 'slideUpOut',
    animationSpeed: 300,
    breakpoint    : '768',
    keyWidth      : '30%',
    valueWidth    : '70%',
    position      : 'top',
  };

  $.fn.copyfit = function(options) {

    if (options === undefined) options = {};

    if(typeof options === "object") {

       return this.each(function() {
        var $this = $(this);

          new $.copyfit(this, options);
      });
    }
  };
}(jQuery));