/// @description  client_queue_msg(buff);
/// @function  client_queue_msg
/// @param buff

var size = buffer_tell(argument[0]);
ds_queue_enqueue(queue_buff_size,size);
ds_queue_enqueue(queue_buff_id,argument[0]);
queue_buff++;