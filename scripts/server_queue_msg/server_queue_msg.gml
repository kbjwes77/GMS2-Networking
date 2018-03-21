/// @description  server_queue_msg(user,buff);
/// @function  server_queue_msg
/// @param user
/// @param buff

var size = buffer_tell(argument[1]);
ds_queue_enqueue(queue_buff_size[argument[0]],size);
ds_queue_enqueue(queue_buff_id[argument[0]],argument[1]);
queue_buff[argument[0]]++;