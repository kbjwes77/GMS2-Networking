game_set_speed(120,gamespeed_fps);
global.dt = round(1000000/60);

msg_enum();

// debug
debug = false;
debug_list = ds_list_create();
debug_alpha = 0;
debug_y = 0;

// user data
cur_user = 0;
max_user = 2;
all_user = 0;
add_debug("[max_user] set to ["+string(max_user)+"]");

// entity data
cur_ent = 0;
max_ent = 128;
all_ent = 0;
add_debug("[max_ent] set to ["+string(max_ent)+"]");

user_id_list    = ds_list_create(); // list of user id's
user_sock_list  = ds_list_create(); // list of sockets
ent_id_list     = ds_list_create(); // list of entity id's
ent_inst_list   = ds_list_create(); // list of instances

user_id_to_sock   = ds_map_create(); // userid -> socket
user_sock_to_id   = ds_map_create(); // socket -> userid
ent_id_to_inst    = ds_map_create(); // entid -> instance
ent_inst_to_id    = ds_map_create(); // instance -> entid

// sockets and buffer queues
for(var i=0; i<max_user; i++;)
    {
    user_connected[i] = false;
    user_info[i] = ds_map_create();
	ping_time[i] = 0;
	pos_time[i] = 0;
	
	// lag simulation (outgoing)
	latency_out[i] = 0;
	msg_out_list[i] = ds_list_create(); // time/buff/size
	msg_out[i] = 0;
	
	// lag simulation (incoming)
	latency_in[i] = 0;
	msg_in_list[i] = ds_list_create(); // time/buff/size
	msg_in[i] = 0;
    }

port = 25565;

// attempt to open listen socket
add_debug("Attempting to open listen socket on port ["+string(port)+"]");
listen = network_create_server_raw(network_socket_tcp,port,max_user);
if (listen < 0)
    add_debug("ERROR: Could not open listen socket on port ["+string(port)+"]",c_red);
else
    add_debug("Successfully opened listen socket on port ["+string(port)+"]");

// netgraph
netgraph_time = 0;
netgraph_show = false;
netgraph_alpha = 0;
netgraph_y = 0;
netgraph_mode = 0;
netgraph_surf = -1;
netgraph_record = true;
netgraph_pos = 0;

netgraph_col[0] = $0039B5; netgraph_str[0] = "Incoming Packets";
netgraph_col[1] = $109CF7; netgraph_str[1] = "Incoming Bytes";
netgraph_col[2] = $29BD84; netgraph_str[2] = "Outgoing Packets";
netgraph_col[3] = $FFAD4A; netgraph_str[3] = "Outgoing Bytes";

for(var i=(600*4)-1; i>=0; i--;)
    netgraph[i] = 0; // msg_in, byte_in, msg_out, byte_out

// generate random maps
randomize();

var seedlist = ds_list_create();
for(var i=0; i<16; i++;)
	ds_list_add(seedlist,i);
ds_list_shuffle(seedlist);

global.gen_seed = seedlist[|irandom(15)];
ds_list_destroy(seedlist);

instance_create_depth(0,0,0,obj_gen);