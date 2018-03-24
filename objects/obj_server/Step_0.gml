var time = get_timer();

for(var i=0; i<max_user; i++;)
    {
    if (user_connected[i])
		{
		user_id = i;
	    sock = ds_map_find_value(user_id_to_sock,i);
		
		// === MSG IN / LATENCY SIMULATION ===
		if (latency_in[i] > 0)
			{
			for(var j=msg_in[i]-1; j>=0; j--;)
				{
				if (time > ds_list_find_value(msg_in_list[i],j*3 + 0))
					{
					buff = ds_list_find_value(msg_in_list[i],j*3 + 1);
					size = ds_list_find_value(msg_in_list[i],j*3 + 2);
					msg_in[i]--;
					repeat(3)
						ds_list_delete(msg_in_list[i],j*3);
			
					buffer_seek(buff,buffer_seek_start,0);
					var msgs = buffer_read(buff,buffer_u8);
					// add_debug(string(msgs)+" Messages Received");
		
					repeat(msgs)
					    server_handle_msg();
		
					netgraph[netgraph_pos+0]++;
					netgraph[netgraph_pos+1] += size;
					}
				}
			}
		else
			{
			for(var j=msg_in[i]-1; j>=0; j--;)
				{
				buff = ds_list_find_value(msg_in_list[i],j*3 + 1);
				size = ds_list_find_value(msg_in_list[i],j*3 + 2);
				msg_in[i]--;
				repeat(3)
					ds_list_delete(msg_in_list[i],j*3);
			
				buffer_seek(buff,buffer_seek_start,0);
				var msgs = buffer_read(buff,buffer_u8);
				// add_debug(string(msgs)+" Messages Received");
		
				repeat(msgs)
					server_handle_msg();
		
				netgraph[netgraph_pos+0]++;
				netgraph[netgraph_pos+1] += size;
				}
			}
		
		// send out player position updates
		if (time > pos_time[i])
			{
			pos_time[i] = time+50000;
			
			var sendbuff = buffer_create(16,buffer_fixed,1);
			buffer_seek(sendbuff,buffer_seek_start,0);
			buffer_write(sendbuff,buffer_u8,s_msg.user_pos);
			buffer_write(sendbuff,buffer_u8,cur_user-1);
			
			// send all player position updates except our own
			for(var j=0; j<max_user; j++;)
				{
				if (user_connected[j]) and (j != i)
					{
					buffer_write(sendbuff,buffer_u8,j);
					
					var inst = ds_map_find_value(user_info[j],"pInst");
					
					if (inst.absolute >= 6)
						{
						inst.absolute = 0;
						
						if (inst.x == inst.x_last) and (inst.y == inst.y_last)
							buffer_write(sendbuff,buffer_u8,0);
						else
							{
							buffer_write(sendbuff,buffer_u8,2);
							buffer_write(sendbuff,buffer_s16,round(inst.x));
							buffer_write(sendbuff,buffer_s16,round(inst.y));
							}
						}
					else
						{
						inst.absolute++;
						
						if (inst.x == inst.x_last) and (inst.y == inst.y_last)
							buffer_write(sendbuff,buffer_u8,0);
						else
							{
							buffer_write(sendbuff,buffer_u8,1);
							buffer_write(sendbuff,buffer_s8,round(inst.x - inst.x_last));
							buffer_write(sendbuff,buffer_s8,round(inst.y - inst.y_last));
							}
						}
					
					inst.x_last = inst.x;
					inst.y_last = inst.y;
					}
				}
			
			server_queue_msg(i,sendbuff);
			}
		
		// send out ping requests
		if (time > ping_time[i])
			{
			ping_time[i] = time+5000000;
		
			var pings = ds_map_find_value(user_info[i],"pings");
			if (pings >= 3)
				{
				add_debug("USER ["+string(i)+"] was disconnected for inactivity",c_red);
				server_user_rmv(i,sock);
		
				// tell remaining users about disconnected user
				for(var j=0; j<max_user; j++;)
					{
					if (user_connected[j])
						{
						var sendbuff = buffer_create(16,buffer_fixed,1);
						buffer_seek(sendbuff,buffer_seek_start,0);
						buffer_write(sendbuff,buffer_u8,s_msg.user_rmv);
						buffer_write(sendbuff,buffer_u8,1);
						buffer_write(sendbuff,buffer_u8,i);
						server_queue_msg(j,sendbuff);
						}
					}
		
				continue;
				}
			else
				{
				ds_map_replace(user_info[i],"pings",pings+1);
			
				var sendbuff = buffer_create(16 + cur_user*2,buffer_fixed,1);
				buffer_seek(sendbuff,buffer_seek_start,0);
				buffer_write(sendbuff,buffer_u8,s_msg.ping);
		
				// write pings of all other users
				buffer_write(sendbuff,buffer_u8,cur_user);
				for(var j=0; j<max_user; j++;)
					{
					if (user_connected[j])
						{
						buffer_write(sendbuff,buffer_u8,j);
						buffer_write(sendbuff,buffer_u8,min(ds_map_find_value(user_info[j],"ping"),1000000)/4000);
						}
					}
		
				server_queue_msg(i,sendbuff);
				}
			}
    
		// === MSG OUT / LATENCY SIMULATION ===
	    if (msg_out[i] > 0)
	        {
			var ind = msg_out[i]-1;
			var num = 0;
	        var bytes = 1;
	        var sendbuff = buffer_create(1024,buffer_fixed,1);
			buffer_seek(sendbuff,buffer_seek_start,1);
        
			if (latency_out[i] > 0)
				{
				// write until buffer is full (avoiding MTU limit) and we don't overflow # of messages
		        while((msg_out[i] > 0) and (ind >= 0) and (num <= 255) and (bytes < 768))
		            {
					if (time > ds_list_find_value(msg_out_list[i],ind*3 + 0))
						{
						var temp_buff = ds_list_find_value(msg_out_list[i],ind*3 + 1);
						var temp_size = ds_list_find_value(msg_out_list[i],ind*3 + 2);
						msg_out[i]--;
						repeat(3)
							ds_list_delete(msg_out_list[i],ind*3);
				
			            buffer_copy(temp_buff,0,temp_size,sendbuff,bytes);
			            buffer_delete(temp_buff);
					
			            bytes += temp_size;
						num++;
						}
					ind--;
		            }
				}
			else
				{
				// write until buffer is full (avoiding MTU limit) and we don't overflow # of messages
		        while((msg_out[i] > 0) and (ind >= 0) and (num <= 255) and (bytes < 768))
		            {
					var temp_buff = ds_list_find_value(msg_out_list[i],ind*3 + 1);
					var temp_size = ds_list_find_value(msg_out_list[i],ind*3 + 2);
					msg_out[i]--;
					repeat(3)
						ds_list_delete(msg_out_list[i],ind*3);
				
			        buffer_copy(temp_buff,0,temp_size,sendbuff,bytes);
			        buffer_delete(temp_buff);
					
			        bytes += temp_size;
					num++;
					ind--;
		            }
				}
			
			// if we buffered data
			if (num > 0)
				{
				buffer_seek(sendbuff,buffer_seek_start,0);
				buffer_write(sendbuff,buffer_u8,num);
		        network_send_raw(sock,sendbuff,bytes);
				
				// log to netgraph
				netgraph[netgraph_pos+2]++;
		        netgraph[netgraph_pos+3] += bytes;
				}
			
	        buffer_delete(sendbuff);
	        }
		}
    }

// netgraph
if (time-netgraph_time > 16000)
	{
	netgraph_time = time;
	
	netgraph_pos += 4;
	if (netgraph_pos+3 > 600*4)
	    netgraph_pos = 0;

	netgraph[netgraph_pos+0] = 0;
	netgraph[netgraph_pos+1] = 0;
	netgraph[netgraph_pos+2] = 0;
	netgraph[netgraph_pos+3] = 0;
	}