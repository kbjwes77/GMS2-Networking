var time = get_timer();

if (pos_time < time-50000)
	{
	pos_time = time;
	
	for(var i=0; i<max_user; i++;)
		{
		if (user_connected[i])
			{
			var sendbuff = buffer_create(16,buffer_fixed,1);
			buffer_seek(sendbuff,buffer_seek_start,0);
			buffer_write(sendbuff,buffer_u8,s_msg.user_pos);
			buffer_write(sendbuff,buffer_u8,cur_user-1);
			
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
		}
	}

for(var i=0; i<cur_user; i++;)
    {
    var temp_user = user_id_list[|i];
    var temp_sock = ds_map_find_value(user_id_to_sock,temp_user);
	
	// send out ping requests
	if (ping_time[temp_user] < time-5000000)
		{
		ping_time[temp_user] = time;
		
		var pings = ds_map_find_value(user_info[temp_user],"pings");
		if (pings >= 3)
			{
			add_debug("USER ["+string(temp_user)+"] was disconnected for inactivity",c_red);
			server_user_rmv(temp_user,temp_sock);
		
			// tell remaining users about disconnected user
			for(var j=0; j<max_user; j++;)
				{
				if (user_connected[j])
					{
					var sendbuff = buffer_create(16,buffer_fixed,1);
					buffer_seek(sendbuff,buffer_seek_start,0);
					buffer_write(sendbuff,buffer_u8,s_msg.user_rmv);
					buffer_write(sendbuff,buffer_u8,1);
					buffer_write(sendbuff,buffer_u8,temp_user);
					server_queue_msg(j,sendbuff);
					}
				}
		
			continue;
			}
		else
			{
			ds_map_replace(user_info[temp_user],"pings",pings+1);
			
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
		
			server_queue_msg(temp_user,sendbuff);
			}
		}
    
    if (queue_buff[temp_user] > 0)
        {
		var num = 0;
        var bytes = 1;
        var sendbuff = buffer_create(1024,buffer_fixed,1);
		buffer_seek(sendbuff,buffer_seek_start,1);
        
        while((queue_buff[temp_user] > 0) and (num <= 255) and (bytes < 768))
            {
            var temp_buff = ds_queue_dequeue(queue_buff_id[temp_user]);
            var temp_size = ds_queue_dequeue(queue_buff_size[temp_user]);
            
            buffer_copy(temp_buff,0,temp_size,sendbuff,bytes);
            buffer_delete(temp_buff);
            
            queue_buff[temp_user]--;
            bytes += temp_size;
			num++;
            }
		
		buffer_seek(sendbuff,buffer_seek_start,0);
		buffer_write(sendbuff,buffer_u8,num);
        
        network_send_raw(temp_sock,sendbuff,bytes);
        buffer_delete(sendbuff);
        
        netgraph[netgraph_pos+2]++;
        netgraph[netgraph_pos+3] += bytes;
        }
    }

// netgraph
netgraph_pos += 4;
if (netgraph_pos+3 > 600*4)
    netgraph_pos = 0;

netgraph[netgraph_pos+0] = 0;
netgraph[netgraph_pos+1] = 0;
netgraph[netgraph_pos+2] = 0;
netgraph[netgraph_pos+3] = 0;