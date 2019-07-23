// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs

var incrementer = (function() {
  var i = {
    increment: function(input) {
      var max = parseInt($(input).attr('max'));
      var value = parseInt($(input).val());
      if(max != undefined) {
        if(value < max) {
          $(input).val(value+1);
        }
      }
      else {
        $(input).val(parseInt($(input).val())+1);
      }
    },
    decrement: function(input) {
      var min = parseInt($(input).attr('min'));
      var value = parseInt($(input).val());
      if(min != undefined) {
        if(value > min) {
          $(input).val(value-1);
        }
      }
      else {
        $(input).val(value-1);
      }

    },
    init: function() {
      $('.incrementer').each(function(index, incrementer) {
        var addButton = $(incrementer).find('.incrementer__add');
        var subtractButton = $(incrementer).find('.incrementer__subtract');
        var input = $(incrementer).find('.text-input');

        $(addButton).click(function(e) {
          i.increment(input);
        });

        $(subtractButton).click(function(e) {
          i.decrement(input);
        });
      });
    }
  }
  return {
    init: i.init
  }
})();

var radioSelector = (function() {
  var rs = {
    init: function() {
      $('.radio-button').each(function(index, button){
        if($(this).find('input').is(':checked')) {
          $(this).addClass('is-selected');
        }

        $(this).find('input').click(function (e) {
          $(this).closest('.radio-button').siblings().removeClass('is-selected')
          $(this).closest('.radio-button').addClass('is-selected')
        })
      })
    }
  }
  return {
    init: rs.init
  }
})();

var checkboxSelector = (function() {
  var cs = {
    init: function() {
      $('.checkbox').each(function(index, button){
        if($(this).find('input').is(':checked')) {
          $(this).addClass('is-selected');
        }

        $(this).find('input').click(function(e) {
          if($(this).is(':checked')) {
            $(this).parent().addClass('is-selected');
          }
          else {
            $(this).parent().removeClass('is-selected');
          }
        })
      })
    }
  }
  return {
    init: cs.init
  }
})();

var followUpQuestion = (function() {
  var fUQ = {
    init: function() {
      $('.question-with-follow-up').each(function(index, question) {
        var self = this;

        // set initial state of follow-ups based on the page
        $(this).find('input').each(function(index, input) {
          if($(this).attr('data-follow-up') != null) {
            $($(this).attr('data-follow-up')).toggle($(this).is(':checked'));
          }
        });

        // add click listeners to initial question inputs
        $(self).find('.question-with-follow-up__question input').click(function(e) {
          // reset follow ups
          $(self).find('.question-with-follow-up__follow-up input').attr('checked', false);
          $(self).find('.question-with-follow-up__follow-up').find('.radio-button, .checkbox').removeClass('is-selected');
          $(self).find('.question-with-follow-up__follow-up').hide();

          // show the current follow up
          if($(this).is(':checked') && $(this).attr('data-follow-up') != null) {
            $($(this).attr('data-follow-up')).show();
          }
        })
      });
    }
  }
  return {
    init: fUQ.init
  }
})();

var revealer = (function() {
  var rv = {
    init: function() {
      $('.reveal').each(function(index, revealer) {
        var self = revealer;
        $(self).addClass('is-hidden');
        $(self).find('.reveal__link').click(function(e) {
          e.preventDefault();
          $(self).toggleClass('is-hidden');
        });
      });
    }
  }
  return {
    init: rv.init
  }
})();

var immediateUpload = (function() {
  var uploader = function() {
    var $formInputs = $('input[type="file"][data-upload-immediately]');

    $formInputs.each(function(index, formInput) {
      var $form = $(formInput).closest('form');
      $form.find("button[type=submit]").hide();
      $form.find('label[for=' + formInput.id + ']').show();
      $(formInput).addClass('file-upload__input');
    }).change(function(event) {
      $(this).closest('form').submit();
      $(this).replaceWith("<h2 class='text--no-top-margin'>" + $formInputs.data("uploading") + "</h2>");
    });
  };

  return {
    init: uploader
  }
})();

var inputGroupSelector = (function() {
  var igs = {
    init: function() {
      $('.text-input-group .text-input').each(function(index, input) {
        if($(this).attr('autofocus')) {
          $(this).parent().addClass('is-focused');
        }
        $(this).focusin(function() {
          $(this).parent().addClass('is-focused');
        })

        $(this).focusout(function() {
          $(this).parent().removeClass('is-focused');
        })

      })
    }
  }
  return {
    init: igs.init
  }
})();

var noneOfTheAbove = (function() {
  var noneOf = {
    init: function () {
      var $noneCheckbox = $('#none__checkbox');
      var $otherCheckboxes = $('input[type=checkbox]').not('#none__checkbox');

      // Uncheck None if another checkbox is checked
      $otherCheckboxes.click(function(e) {
        $noneCheckbox.prop('checked', false);
        $noneCheckbox.parent().removeClass('is-selected');
      });

      // Uncheck all others if None is checked
      $noneCheckbox.click(function(e) {
        $otherCheckboxes.prop('checked', false);
        $otherCheckboxes.parent().removeClass('is-selected');
      });
    }
  };
  return {
    init: noneOf.init
  }
})();

var showMore = (function () {
  return {
    init: function () {
      $('.show-more').each(function (index, showmore) {
        $(showmore).find('.show-more__button').click(function (e) {
          e.preventDefault();
          $(showmore).addClass('is-open');
        })
      });
    }
  }
})();


$(document).ready(function() {
  radioSelector.init();
  checkboxSelector.init();
  followUpQuestion.init();
  immediateUpload.init();
  revealer.init();
  inputGroupSelector.init();
  noneOfTheAbove.init();
  showMore.init();
});
