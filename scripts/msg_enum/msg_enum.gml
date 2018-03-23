/// msg_enum();

enum s_msg
	{
	welcome,
	user_add,
	user_rmv,
	user_info,
	user_chat,
	user_pos,
	user_pos_fix,
	ping
	}

enum c_msg
	{
	goodbye,
	user_info,
	user_chat,
	user_keys,
	user_pos_fix,
	ping
	}

if (instance_exists(obj_server))
	{
	msg_info[c_msg.goodbye]			= "c_msg.goodbye";
	msg_info[c_msg.user_info]		= "c_msg.user_info";
	msg_info[c_msg.user_chat]		= "c_msg.user_chat";
	msg_info[c_msg.user_keys]		= "c_msg.user_keys";
	msg_info[c_msg.user_pos_fix]	= "c_msg.user_pos_fix";
	msg_info[c_msg.ping]			= "c_msg.ping";
	}
else
	{
	msg_info[s_msg.welcome]			= "s_msg.welcome";
	msg_info[s_msg.user_add]		= "s_msg.user_add";
	msg_info[s_msg.user_rmv]		= "s_msg.user_rmv";
	msg_info[s_msg.user_info]		= "s_msg.user_info";
	msg_info[s_msg.user_chat]		= "s_msg.user_chat";
	msg_info[s_msg.user_pos]		= "s_msg.user_pos";
	msg_info[s_msg.user_pos_fix]	= "s_msg.user_pos_fix";
	msg_info[s_msg.ping]			= "s_msg.ping";
	}