/// @description  client_queue_msg(buff);
/// @function  client_queue_msg
/// @param buff

ds_list_add(msg_out_list,get_timer()+latency_out,argument[0],buffer_tell(argument[0]));
msg_out++;