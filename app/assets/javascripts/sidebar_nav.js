//= require jquery3
$(document).ready(function() {
    $('.sidebar-nav').on('click', 'a', function ()
    {
        if( $('.sidebar-collapse-toggle').is(':visible') ) {
            collapseSidebar();
        }
    });

    setSelectedState();

    $(window).on('hashchange', function() {
        setSelectedState();
    });
});

function toggleNav() {
    if($(".sidebar").is(":hidden"))
    {
      openSidebar();
    }
    else
    {
      collapseSidebar();
    }
}

function collapseSidebar() {
  $('.sidebar-collapse-toggle').text('Menu');
  $(".sidebar").removeClass("open");
}

function openSidebar() {
  $('.sidebar-collapse-toggle').text('Close');
  $(".sidebar").addClass("open");
}

function setSelectedState() {
  $('.sidebar__sub-items li').removeClass("active");

  var url_array = window.location.toString().split("/");
  var page = url_array[url_array.length - 1].split("#")[0];

  if (page !== "styleguide") {
    var sidebar_page_match = $('.sidebar__sub-items a[href*="' + page + '"]');
    if (sidebar_page_match.length) {
      sidebar_page_match.parent().addClass('active');
    }
  }
  else {
    if (window.location.hash) {
      $('.sidebar__sub-items a[href*="' + window.location.hash + '"]').parent().addClass("active");
    }
  }
}
