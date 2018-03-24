/// @description  server_queue_msg(user,buff);
/// @function  server_queue_msg
/// @param user
/// @param buff

ds_list_add(msg_out_list[argument[0]],get_timer()+latency_out[argument[0]],argument[1],buffer_tell(argument[1]));
msg_out[argument[0]]++;