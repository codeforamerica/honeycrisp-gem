//= require jquery.stickytableheaders

$(function(){
  $('.js-sticky-header').stickyTableHeaders();

  function parseParams(query) {
    var decode = function (str) {return decodeURIComponent( str.replace(/\+/g, " ") );};

    var re = /([^&=]+)=?([^&]*)/g;
    var params = {};
    var e;

    while ( e = re.exec(query) ) {
      var k = decode( e[1] ), v = decode( e[2] );
      if (k.substring(k.length - 2) === '[]') {
        k = k.substring(0, k.length - 2);
        (params[k] || (params[k] = [])).push(v);
      }
      else params[k] = v;
    }
    return params;
  }

  var QueryParams = {
    getAsObject: function () {
      return parseParams(window.location.search.replace(/^\?/, ''));
    },

    setFromObject: function (params) {
      var paramString = $.param(params);
      var newUrlParts = [window.location.pathname];
      if (paramString.length > 0) {
        newUrlParts.push(paramString);
      }
      window.history.replaceState({}, null, newUrlParts.join('?'));
    },

    addUrlParameter: function(param, value) {
      var params = this.getAsObject();
      params[param] = value;
      this.setFromObject(params);
    },

    removeUrlParameter: function(param) {
      var params = this.getAsObject();
      delete params[param];
      this.setFromObject(params);
    }
  };

  var dailyDrive = (function() {
    return {
      init: function() {
        var $driveStatusFilters = $('.admin-filter-drive-status');
        if ($driveStatusFilters.length === 0) {
          return;
        }

        $('.admin-application-card-show-all-errors').click(function (e) {
          e.preventDefault();
          var $link = $(this);
          $link.closest('.admin-application-card').addClass('admin-application-card--showing-all-errors');
        });

        function setApplicationFilterState(statusToShow) {
          $('.admin-filter-drive-status').css({'font-weight': 'normal'});
          $('.admin-filter-drive-status[data-status=' + statusToShow + ']').css({'font-weight': 'bold'});
          if (statusToShow) {
            QueryParams.addUrlParameter('app-status', statusToShow);
            $('.admin-application-card').hide();
            $('.admin-application-card.' + statusToShow).show();
          } else {
            QueryParams.removeUrlParameter('app-status');
            $('.admin-application-card').show();
          }
        }

        $driveStatusFilters.click(function (e) {
          e.preventDefault();

          var statusToShow = $(this).data('status');
          setApplicationFilterState(statusToShow);
        });

        var params = QueryParams.getAsObject();
        if (params['app-status']) {
          setApplicationFilterState(params['app-status']);
        }
      }
    }
  })();

  $(document).ready(function() {
    dailyDrive.init();
  });
});
