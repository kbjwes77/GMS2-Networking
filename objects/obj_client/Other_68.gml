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
		var temp_time = get_timer() + latency_in;
		var temp_buff = buffer_create(size,buffer_fixed,1);
		buffer_copy(buff,0,size,temp_buff,0);
			
		ds_list_add(msg_in_list,temp_time,temp_buff,size);
		msg_in++;
		}
    }