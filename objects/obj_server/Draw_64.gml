if (keyboard_check_pressed(vk_f1))
    debug = !debug;

if (debug)
    {
	debug_alpha += (1 - debug_alpha)*0.25;
    debug_y += (256 - debug_y)*0.25;
    }
else
    {
	debug_alpha += (0 - debug_alpha)*0.25;
    debug_y += (0 - debug_y)*0.25;
    }

if (debug_alpha > 0)
    {
    draw_set_alpha(debug_alpha);
    draw_set_color($000000);
    draw_rectangle(0,0,800,debug_y,0);
	
	draw_set_color($424242);
	draw_text(8,debug_y-248,"SERVER DEBUG CONSOLE");
    
    for(var i=0; i<ds_list_size(debug_list)/2; i++;)
        {
        var col = debug_list[|i*2];
        var str = debug_list[|i*2 + 1];
        draw_set_color(col);
        draw_text(8,(debug_y-24) - i*20,string(str));
        }
	
    draw_set_color($000000);
    draw_set_alpha(1.0);
    }

if (keyboard_check_pressed(vk_f2))
	netgraph_show = !netgraph_show;

if (keyboard_check_pressed(vk_f3))
	{
	netgraph_mode++;
	if (netgraph_mode > 3)
		netgraph_mode = 0;
	}

if (netgraph_alpha)
	{
	if (surface_exists(netgraph_surf))
		draw_surface_ext(netgraph_surf,0,600-netgraph_y,1,1,0,$FFFFFF,netgraph_alpha);
	}