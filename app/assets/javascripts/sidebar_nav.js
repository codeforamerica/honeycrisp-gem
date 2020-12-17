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
  setActiveNavigationItem(window.location.pathname)
  setActiveNavigationItem(window.location.pathname + window.location.hash)
}

function setActiveNavigationItem(hrefValue) {
  $('.sidebar__sub-items a[href="' + hrefValue + '"]').parent().addClass('active');
}
