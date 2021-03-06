type = ds_map_find_value(async_load,"type");
sock = ds_map_find_value(async_load,"id");
port = ds_map_find_value(async_load,"port");
ip   = ds_map_find_value(async_load,"ip");

// incoming data
if (type == network_type_data)
    {
    buff = ds_map_find_value(async_load,"buffer");
    size = ds_map_find_value(async_load,"size");
    
	if (size > 0)
		{
		// incoming message handling
		var temp_user = ds_map_find_value(user_sock_to_id,sock);
		var temp_time = get_timer() + latency_in[temp_user];
		var temp_buff = buffer_create(size,buffer_fixed,1);
		buffer_copy(buff,0,size,temp_buff,0);
			
		ds_list_add(msg_in_list[temp_user],temp_time,temp_buff,size);
		msg_in[temp_user]++;
		}
    }
// user attempting to connect
else if (type == network_type_connect)
    {
    var temp_sock = ds_map_find_value(async_load,"socket");
    var succeeded = ds_map_find_value(async_load,"succeeded");
    
    var temp_id = -1;
    if (cur_user < max_user)
        {
        for(var i=0; i<max_user; i++;)
            {
            if !(user_connected[i])
                {
                temp_id = i;
                break;
                }
            }
        }
    
    // connection successful
    if (temp_id > -1)
        {
        add_debug("User successfully connected, using slot["+string(temp_id)+"]",c_lime);
        server_user_add(temp_id,temp_sock,ip,port);
		
		// tell all existing users about new user
		for(var i=0; i<max_user; i++;)
			{
			if (user_connected[i]) and (i != temp_id)
				{
				var sendbuff = buffer_create(16,buffer_fixed,1);
				buffer_seek(sendbuff,buffer_seek_start,0);
				buffer_write(sendbuff,buffer_u8,s_msg.user_add);
				buffer_write(sendbuff,buffer_u8,1);
				buffer_write(sendbuff,buffer_u8,temp_id);
				server_queue_msg(i,sendbuff);
				}
			}
		
		// tell new user about all existing users
		var sendbuff = buffer_create(32+cur_user,buffer_fixed,1);
		buffer_seek(sendbuff,buffer_seek_start,0);
		buffer_write(sendbuff,buffer_u8,s_msg.welcome);
		buffer_write(sendbuff,buffer_u8,temp_id);
		buffer_write(sendbuff,buffer_u8,max_user);
		buffer_write(sendbuff,buffer_u8,cur_user);
		buffer_write(sendbuff,buffer_u8,max_ent);
		buffer_write(sendbuff,buffer_u8,cur_ent);
		
		for(var i=0; i<max_user; i++;)
			{
			if (user_connected[i])
				buffer_write(sendbuff,buffer_u8,i);
			}
		
		buffer_write(sendbuff,buffer_u32,global.gen_seed);
		buffer_write(sendbuff,buffer_u16,obj_gen.spawn_x);
		buffer_write(sendbuff,buffer_u16,obj_gen.spawn_y);
		
		server_queue_msg(temp_id,sendbuff);
		
		pos_time[temp_id] = get_timer()+50000;
		ping_time[temp_id] = get_timer()+5000000;
        }
    else
        {
        add_debug("Server full, killing connection",c_gray);
        network_destroy(temp_sock);
        }
    }