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
});

$(window).resize(function() {
    //needed jquery resize for when someone changes screen size
    //works if same size but gets caught in either mobile or desktop without this
    if( $('.sidebar-collapse-toggle').first().is(':hidden') )
    {
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