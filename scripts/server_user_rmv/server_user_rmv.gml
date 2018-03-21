/// server_user_rmv(user,sock);
/// @function  server_user_rmv
/// @param user
/// @param sock

var sendbuff = buffer_create(16,buffer_fixed,1);
buffer_seek(sendbuff,buffer_seek_start,0);
buffer_write(sendbuff,buffer_u8,1);
buffer_write(sendbuff,buffer_u8,s_msg.user_rmv);
buffer_write(sendbuff,buffer_u8,1);
buffer_write(sendbuff,buffer_u8,argument[0]);

bytes = buffer_tell(sendbuff);
network_send_raw(argument[1],sendbuff,bytes);
buffer_delete(sendbuff);

netgraph[netgraph_pos+2]++;
netgraph[netgraph_pos+3] += bytes;

ds_queue_clear(queue_buff_size[argument[0]]);
ds_queue_clear(queue_buff_id[argument[0]]);
queue_buff[argument[0]] = 0;

user_connected[argument[0]] = false;
ping_time[argument[0]] = 0;

ds_map_clear(user_info[argument[0]]);
network_destroy(argument[1]);

var _pos = ds_list_find_index(user_id_list,argument[0]);
if (_pos > -1)
	ds_list_delete(user_id_list,_pos);

var _pos = ds_list_find_index(user_sock_list,argument[1]);
if (_pos > -1)
	ds_list_delete(user_sock_list,_pos);

if (ds_map_exists(user_id_to_sock,argument[0]))
	ds_map_delete(user_id_to_sock,argument[0]);

if (ds_map_exists(user_sock_to_id,argument[1]))
	ds_map_delete(user_sock_to_id,argument[1]);

cur_user--;