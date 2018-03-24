/// @description  client_handle_msg();
/// @function  client_handle_msg

var msg_id = buffer_read(buff,buffer_u8);
// add_debug("MSG["+string(msg_info[msg_id])+"]");

switch(msg_id)
    {
	case s_msg.welcome: // welcome message from server
		client_id = buffer_read(buff,buffer_u8);
		add_debug("Successfully connected to server, using slot["+string(client_id)+"]",c_lime);
		
		max_user = buffer_read(buff,buffer_u8);
		cur_user = buffer_read(buff,buffer_u8);
		max_ent = buffer_read(buff,buffer_u8);
		cur_ent = buffer_read(buff,buffer_u8);
		add_debug("["+string(cur_user)+"/"+string(max_user)+"] users");
		add_debug("["+string(cur_ent)+"/"+string(max_ent)+"] entities");
		
		for(var i=0; i<max_user; i++;)
			{
			user_connected[i] = false;
			user_info[i] = ds_map_create();
			}
		
		for(var i=0; i<cur_user; i++;)
			{
			var temp_id = buffer_read(buff,buffer_u8);
			user_connected[temp_id] = true;
			
			if (temp_id == client_id)
				var inst = instance_create_depth(0,0,0,obj_client_player_slave);
			else
				var inst = instance_create_depth(0,0,0,obj_client_player);
			ds_map_set(user_info[temp_id],"pInst",inst);
			}
		
		global.gen_seed = buffer_read(buff,buffer_u32);
		var temp_x = buffer_read(buff,buffer_u16);
		var temp_y = buffer_read(buff,buffer_u16);
		var inst = instance_create_depth(0,0,0,obj_gen);
		inst.spawn_x = temp_x;
		inst.spawn_y = temp_y;
		
		var inst = instance_create_depth(0,0,0,obj_player_controller);
		inst.slave = ds_map_find_value(user_info[client_id],"pInst");
		
		var seek = buffer_tell(buff);
		break;
	
	case s_msg.user_add:
		var num = buffer_read(buff,buffer_u8);
		repeat(num)
			{
			var temp_id = buffer_read(buff,buffer_u8);
			
			user_connected[temp_id] = true;
			var inst = instance_create_depth(0,0,0,obj_client_player);
			ds_map_set(user_info[temp_id],"pInst",inst);
			}
		
		var seek = buffer_tell(buff);
		break;
	
	case s_msg.user_rmv:
		var num = buffer_read(buff,buffer_u8);
		repeat(num)
			{
			var temp_id = buffer_read(buff,buffer_u8);
			
			if (temp_id == client_id)
				add_debug("You were disconnected from server",c_red);
			else
				add_debug("User ["+string(temp_id)+"] disconnected");
			
			var inst = ds_map_find_value(user_info[temp_id],"pInst");
			if (instance_exists(inst))
				instance_destroy(inst);
			
			user_connected[temp_id] = false;
			ds_map_clear(user_info[temp_id]);
			}
		
		var seek = buffer_tell(buff);
		break;
	
	case s_msg.user_pos: // user position updated
		
		var temp_loop = buffer_read(buff,buffer_u8);
		repeat(temp_loop)
			{
			var temp_id = buffer_read(buff,buffer_u8);
			var flags = buffer_read(buff,buffer_u8);
			
			var inst = ds_map_find_value(user_info[temp_id],"pInst");
			
			if (flags == 2)
				{
				var temp_x = buffer_read(buff,buffer_s16);
				var temp_y = buffer_read(buff,buffer_s16);
				ds_list_add(inst.px,temp_x);
				ds_list_add(inst.py,temp_y);
				inst.points++;
				}
			else if (flags == 1)
				{
				var temp_x = buffer_read(buff,buffer_s8);
				var temp_y = buffer_read(buff,buffer_s8);
				var copy_x = inst.px[|inst.points-1];
				var copy_y = inst.py[|inst.points-1];
				ds_list_add(inst.px,copy_x + temp_x);
				ds_list_add(inst.py,copy_y + temp_y);
				inst.points++;
				}
			}
		
		var seek = buffer_tell(buff);
		break;
	
	case s_msg.user_pos_fix: // user position fix
		
		var temp_pos = buffer_read(buff,buffer_u8);
		var temp_x = buffer_read(buff,buffer_s16);
		var temp_y = buffer_read(buff,buffer_s16);
		var seek = buffer_tell(buff);
		
		var sendbuff = buffer_create(16,buffer_fixed,1);
		buffer_seek(sendbuff,buffer_seek_start,0);
		buffer_write(sendbuff,buffer_u8,c_msg.user_pos_fix);
		client_queue_msg(sendbuff);
		
		var inst = ds_map_find_value(user_info[client_id],"pInst");
		if (instance_exists(inst))
			{
			var xadd = temp_x - obj_player_controller.xsent[temp_pos];
			var yadd = temp_y - obj_player_controller.ysent[temp_pos];
			add_debug("Player position desync, error ["+string(xadd)+","+string(yadd)+"]",c_orange);
			inst.x += xadd;
			inst.y += yadd;
			
			with(obj_player_controller)
				{
				for(var i=0; i<sendnum; i++;)
					{
					if (tsent[i] >= tsent[temp_pos])
						{
						xsent[i] += xadd;
						ysent[i] += yadd;
						}
					}
				}
			}
		break;
	
    case s_msg.ping: // ping request
		var num = buffer_read(buff,buffer_u8);
		repeat(num)
			{
			var temp_id = buffer_read(buff,buffer_u8);
			var temp_ping = buffer_read(buff,buffer_u8);
			
			if (user_connected[temp_id])
				ds_map_replace(user_info[temp_id],"ping",temp_ping*4000)
			}
		
		var seek = buffer_tell(buff);
		
		var sendbuff = buffer_create(16,buffer_fixed,1);
		buffer_seek(sendbuff,buffer_seek_start,0);
		buffer_write(sendbuff,buffer_u8,c_msg.ping);
		client_queue_msg(sendbuff);
		
        break;
    }

buffer_seek(buff,buffer_seek_start,seek);