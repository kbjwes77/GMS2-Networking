if (button(700,500,"Disconnect"))
	{
	if (client_id > -1)
		{
		add_debug("Disconnected from server",c_red);
		
		ds_queue_clear(queue_buff_size);
		ds_queue_clear(queue_buff_id);
		queue_buff = 0;
		
		sendbuff = buffer_create(16,buffer_fixed,1);
		buffer_seek(sendbuff,buffer_seek_start,0);
		buffer_write(sendbuff,buffer_u8,1);
		buffer_write(sendbuff,buffer_u8,c_msg.goodbye);
		
		bytes = buffer_tell(sendbuff);
		network_send_raw(connect,sendbuff,bytes);
		buffer_delete(sendbuff);
		
		netgraph[netgraph_pos+2]++;
		netgraph[netgraph_pos+3] += bytes;
		
		for(var i=0; i<max_user; i++;)
			{
			ds_map_clear(user_info[i]);
			user_connected[i] = false;
			}
		
		client_id = -1;
		max_user = 0;
		cur_user = 0;
		max_ent = 0;
		cur_ent = 0;
		}
	}

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
	draw_text(8,debug_y-248,"CLIENT DEBUG CONSOLE");
    
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