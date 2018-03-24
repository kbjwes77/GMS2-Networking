var old_keys = keys;

// press a key
keys = 0;
if (keyboard_check(ord("A")))
	keys += 1;
if (keyboard_check(ord("D")))
	keys += 2;
if (keyboard_check(ord("W")))
	keys += 4;
if (keyboard_check(ord("S")))
	keys += 8;

if (keys != old_keys) and (instance_exists(slave))
	{
	// set slave's keys
	slave.keys = keys;
	
	// expose variables so client can send them to server
	var temp_pos = sendpos;
	var temp_x = floor(slave.x);
	var temp_y = floor(slave.y);
	
	// log the position we are sending to server
	xsent[sendpos] = temp_x;
	ysent[sendpos] = temp_y;
	tsent[sendpos] = get_timer();
	sendpos++;
	if (sendpos > sendnum-1)
		sendpos = 0;
	
	with(obj_client)
		{
		var sendbuff = buffer_create(16,buffer_fixed,1);
		buffer_seek(sendbuff,buffer_seek_start,0);
		buffer_write(sendbuff,buffer_u8,c_msg.user_keys);
		buffer_write(sendbuff,buffer_u8,other.keys);
		buffer_write(sendbuff,buffer_u8,temp_pos);
		buffer_write(sendbuff,buffer_s16,temp_x);
		buffer_write(sendbuff,buffer_s16,temp_y);
		client_queue_msg(sendbuff);
		}
	}