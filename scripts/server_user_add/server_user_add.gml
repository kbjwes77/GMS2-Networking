/// server_user_add(user,sock,ip,port);
/// @function server_user_add
/// @param user
/// @param sock
/// @param ip
/// @param port

var inst = instance_create_depth(obj_gen.spawn_x*16 + 8,obj_gen.spawn_y*16 + 8,0,obj_server_player);

user_connected[argument[0]] = true;
ping_time[argument[0]] = get_timer();
		
ds_map_add(user_info[argument[0]],"ip",argument[2]);
ds_map_add(user_info[argument[0]],"port",argument[3]);
ds_map_add(user_info[argument[0]],"ping",0);
ds_map_add(user_info[argument[0]],"pings",0);
ds_map_add(user_info[argument[0]],"time_in",date_current_datetime());
ds_map_add(user_info[argument[0]],"pInst",inst);

ds_list_add(user_id_list,argument[0]);
ds_list_add(user_sock_list,argument[1]);
ds_map_set(user_id_to_sock,argument[0],argument[1]);
ds_map_set(user_sock_to_id,argument[1],argument[0]);

cur_user++;
all_user++;