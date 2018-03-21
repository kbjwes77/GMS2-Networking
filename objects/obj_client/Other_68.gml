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
	    buffer_seek(buff,buffer_seek_start,0);
	    var msgs = buffer_read(buff,buffer_u8);
		// add_debug(string(msgs)+" Messages Received");
		
	    repeat(msgs)
	        client_handle_msg();
    
	    netgraph[netgraph_pos+0]++;
	    netgraph[netgraph_pos+1] += size;
		}
    }