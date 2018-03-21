if (queue_buff > 0)
    {
	var num = 0;
    var bytes = 1;
    var sendbuff = buffer_create(1024,buffer_fixed,1);
	buffer_seek(sendbuff,buffer_seek_start,1);
    
    while((queue_buff > 0) and (num <= 255) and (bytes < 768))
        {
        var temp_buff = ds_queue_dequeue(queue_buff_id);
        var temp_size = ds_queue_dequeue(queue_buff_size);
        
        buffer_copy(temp_buff,0,temp_size,sendbuff,bytes);
        buffer_delete(temp_buff);
        
        queue_buff--;
        bytes += temp_size;
		num++;
        }
	
	buffer_seek(sendbuff,buffer_seek_start,0);
	buffer_write(sendbuff,buffer_u8,num);
    
    network_send_raw(connect,sendbuff,bytes);
    buffer_delete(sendbuff);
    
    netgraph[netgraph_pos+2]++;
    netgraph[netgraph_pos+3] += bytes;
    }

// netgraph
netgraph_pos += 4;
if (netgraph_pos+3 > 600*4)
    netgraph_pos = 0;

netgraph[netgraph_pos+0] = 0;
netgraph[netgraph_pos+1] = 0;
netgraph[netgraph_pos+2] = 0;
netgraph[netgraph_pos+3] = 0;