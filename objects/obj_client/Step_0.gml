var time = get_timer();

// === MSG IN / LATENCY SIMULATION ===
if (latency_in > 0)
	{
	for(var i=msg_in-1; i>=0; i--;)
		{
		if (time > ds_list_find_value(msg_in_list,i*3 + 0))
			{
			buff = ds_list_find_value(msg_in_list,i*3 + 1);
			size = ds_list_find_value(msg_in_list,i*3 + 2);
			msg_in--;
			repeat(3)
				ds_list_delete(msg_in_list,i*3);
		
			buffer_seek(buff,buffer_seek_start,0);
			var msgs = buffer_read(buff,buffer_u8);
			// add_debug(string(msgs)+" Messages Received");
		
			repeat(msgs)
			    client_handle_msg();
		
			netgraph[netgraph_pos+0]++;
			netgraph[netgraph_pos+1] += size;
			}
		}
	}
else
	{
	for(var i=msg_in-1; i>=0; i--;)
		{
		buff = ds_list_find_value(msg_in_list,i*3 + 1);
		size = ds_list_find_value(msg_in_list,i*3 + 2);
		msg_in--;
		repeat(3)
			ds_list_delete(msg_in_list,i*3);
		
		buffer_seek(buff,buffer_seek_start,0);
		var msgs = buffer_read(buff,buffer_u8);
		// add_debug(string(msgs)+" Messages Received");
		
		repeat(msgs)
			client_handle_msg();
		
		netgraph[netgraph_pos+0]++;
		netgraph[netgraph_pos+1] += size;
		}
	}

// === MSG OUT / LATENCY SIMULATION ===
if (msg_out > 0)
	{
	var ind = msg_out-1;
	var num = 0;
	var bytes = 1;
	var sendbuff = buffer_create(1024,buffer_fixed,1);
	buffer_seek(sendbuff,buffer_seek_start,1);
    
	if (latency_out > 0)
		{
		// write until buffer is full (avoiding MTU limit) and we don't overflow # of messages
		while((msg_out > 0) and (ind >= 0) and (num <= 255) and (bytes < 768))
		    {
			if (time > ds_list_find_value(msg_out_list,ind*3 + 0))
				{
				var temp_buff = ds_list_find_value(msg_out_list,ind*3 + 1);
				var temp_size = ds_list_find_value(msg_out_list,ind*3 + 2);
				msg_out--;
				repeat(3)
					ds_list_delete(msg_out_list,ind*3);
				
			    buffer_copy(temp_buff,0,temp_size,sendbuff,bytes);
			    buffer_delete(temp_buff);
					
			    bytes += temp_size;
				num++;
				}
			ind--;
		    }
		}
	else
		{
		// write until buffer is full (avoiding MTU limit) and we don't overflow # of messages
		while((msg_out > 0) and (ind >= 0) and (num <= 255) and (bytes < 768))
		    {
			var temp_buff = ds_list_find_value(msg_out_list,ind*3 + 1);
			var temp_size = ds_list_find_value(msg_out_list,ind*3 + 2);
			msg_out--;
			repeat(3)
				ds_list_delete(msg_out_list,ind*3);
				
			buffer_copy(temp_buff,0,temp_size,sendbuff,bytes);
			buffer_delete(temp_buff);
					
			bytes += temp_size;
			num++;
			ind--;
		    }
		}
	
	// if we buffered data
	if (num > 0)
		{
		buffer_seek(sendbuff,buffer_seek_start,0);
		buffer_write(sendbuff,buffer_u8,num);
		network_send_raw(connect,sendbuff,bytes);
		
		// log to netgraph
		netgraph[netgraph_pos+2]++;
		netgraph[netgraph_pos+3] += bytes;
		}
	
	buffer_delete(sendbuff);
	}

// netgraph
if (time-netgraph_time > 16000)
	{
	netgraph_time = time;
	
	netgraph_pos += 4;
	if (netgraph_pos+3 > 600*4)
	    netgraph_pos = 0;

	netgraph[netgraph_pos+0] = 0;
	netgraph[netgraph_pos+1] = 0;
	netgraph[netgraph_pos+2] = 0;
	netgraph[netgraph_pos+3] = 0;
	}