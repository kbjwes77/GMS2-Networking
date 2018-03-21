var msg_id = buffer_read(buff,buffer_u8);
// add_debug("MSG["+string(msg_info[msg_id])+"]");

switch(msg_id)
    {
	case c_msg.goodbye:
		var seek = buffer_tell(buff);
		
		add_debug("USER ["+string(user_id)+"] disconnected",c_red);
		server_user_rmv(user_id,sock);
		
		for(var i=0; i<max_user; i++;)
			{
			if (user_connected[i])
				{
				var sendbuff = buffer_create(16,buffer_fixed,1);
				buffer_seek(sendbuff,buffer_seek_start,0);
				buffer_write(sendbuff,buffer_u8,s_msg.user_rmv);
				buffer_write(sendbuff,buffer_u8,1);
				buffer_write(sendbuff,buffer_u8,user_id);
				server_queue_msg(i,sendbuff);
				}
			}
		
		break;
	
	case c_msg.user_keys: // player updated keys
		var keys = buffer_read(buff,buffer_u8);
		var seek = buffer_tell(buff);
		
		var inst = ds_map_find_value(user_info[user_id],"pInst");
		if (instance_exists(inst))
			inst.keys = keys;
		break;
	
    case c_msg.ping: // ping reply
        var ping = max(get_timer()-ping_time[user_id],0);
        ds_map_replace(user_info[user_id],"ping",ping);
		ds_map_replace(user_info[user_id],"pings",0);
		
		var seek = buffer_tell(buff);
        break;
    }

buffer_seek(buff,buffer_seek_start,seek);