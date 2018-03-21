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
	slave.keys = keys;
	var temp_slave = slave;
	
	with(obj_client)
		{
		var sendbuff = buffer_create(16,buffer_fixed,1);
		buffer_seek(sendbuff,buffer_seek_start,0);
		buffer_write(sendbuff,buffer_u8,c_msg.user_keys);
		buffer_write(sendbuff,buffer_u8,temp_slave.keys);
		client_queue_msg(sendbuff);
		}
	}