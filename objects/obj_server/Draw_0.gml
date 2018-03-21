for(var i=0; i<max_user; i++;)
    {
    if (user_connected[i])
        {
        draw_text(12,12 + i*20,string("USER["+string(i)+"] - "+string(ip)+":"+string(port)));
        }
    }

if (netgraph_show)
    {
	netgraph_alpha += (1 - netgraph_alpha)*0.25;
    netgraph_y += (200 - netgraph_y)*0.25;
    }
else
    {
	netgraph_alpha += (0 - netgraph_alpha)*0.25;
    netgraph_y += (0 - netgraph_y)*0.25;
    }
	
if (netgraph_alpha > 0)
	{
	if !(surface_exists(netgraph_surf))
		netgraph_surf = surface_create(800,200);
	
	surface_set_target(netgraph_surf);
	draw_clear(c_black);
	
	draw_set_color($424242);
	draw_text(8,8,string(netgraph_str[netgraph_mode]));
	draw_set_color($000000);
	
	var l = 100;
	var w = 800/l;
	
	var n1 = netgraph_pos - l*4;
	if (n1 < 0)
		n1 += 600*4;
	
	draw_primitive_begin(pr_linestrip);
	
	for(var i=0; i<l; i++;)
		draw_vertex_color(i*w,199 - netgraph[(n1+netgraph_mode + i*4) mod (600*4)],netgraph_col[netgraph_mode],1);
	
	draw_primitive_end();
	
	surface_reset_target();
	}