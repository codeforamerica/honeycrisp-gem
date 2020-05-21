//= require jquery
$(document).ready(function() {
    //collapse menu if its mobile and you click a link in menu sub items
    $('.sidebar-nav').on('click', 'a', function ()
    {
        if( $('.sidebar-collapse-toggle').is(':visible') ) {
            $(".sidebar").css({
                "width": "17em",
                "display": "none"
            });
            $(".left-sidebar-slab-container").css({
                "margin-left": "0",
                "padding-left": "0"
            });
        }
    });

    setSelectedState();

    $(window).on('hashchange', function() {
        setSelectedState();
    });
});

$(window).resize(function() {
    //needed jquery resize for when someone changes screen size
    //works if same size but gets caught in either mobile or desktop without this
    if( $('.sidebar-collapse-toggle').first().is(':hidden') )
    {
        $('.sidebar-collapse-toggle').text('Close');
        $(".sidebar").css({
            "display" : "inline-block"
        });
        $(".sidebar-nav").css({
            "width": "12em"
        });
        $(".left-sidebar-slab-container").css({
            "margin-left": "11em",
            "padding-left": "1em"
        });
    }
    else
    {
        $('.sidebar-collapse-toggle').text('Menu');
        $(".sidebar").css({
            "width": "17em",
            "display" : "none"
        });

        $(".left-sidebar-slab-container").css({
            "margin-left": "0",
            "padding-left": "0"
        });
    }
});

function toggleNav() {
    if($(".sidebar").is(":hidden"))
    {
        $('.sidebar-collapse-toggle').text('Close');
        $(".sidebar").css({
            "display" : "inline-block"
        });

        $(".sidebar-nav").css({
            "width": "100%"
        });

        $(".left-sidebar-slab-container").css({
            "margin-left": "11em",
            "padding-left": "1em"
        });
    }
    else
    {
        $('.sidebar-collapse-toggle').text('Menu');
        $(".sidebar").css({
            "width": "17em",
            "display" : "none"
        });
        $(".left-sidebar-slab-container").css({
            "margin-left": "0",
            "padding-left": "0"
        });
    }
}

function setSelectedState() {
  $('.sidebar-nav ul li .sidebar__sub-items li a').removeClass("active");

  let url_array = window.location.toString().split("/");
  let page = url_array[url_array.length - 1].split("#")[0];

  if (page !== "styleguide") {
    let sidebar_page_match = $('.sidebar-nav ul li .sidebar__sub-items li a[href*="' + page + '"]');
    if (sidebar_page_match.length) {
      sidebar_page_match.addClass('active');
    }
  }
  else {
    if (window.location.hash) {
      $('.sidebar-nav ul li .sidebar__sub-items li a[href*="' + window.location.hash + '"]').addClass("active");
    }
  }
}
