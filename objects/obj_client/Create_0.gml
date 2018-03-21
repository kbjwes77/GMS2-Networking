msg_enum();

debug = false;
debug_list = ds_list_create();
debug_alpha = 0;
debug_y = 0;

server_ip = "127.0.0.1";
server_port = 25565;

client_id = -1;

pos_time = 0;

// user data
cur_user = 0;
max_user = 0;

// entity data
cur_ent = 0;
max_ent = 0;

ent_id_list     = ds_list_create(); // list of entity id's
ent_inst_list   = ds_list_create(); // list of instances

ent_id_to_inst    = ds_map_create(); // entid -> instance
ent_inst_to_id    = ds_map_create(); // instance -> entid

// buffer queue
queue_buff_size = ds_queue_create();
queue_buff_id = ds_queue_create();
queue_buff = 0;

// attempt to connect to server
add_debug("Attemping to connect to server ["+string(server_ip)+":"+string(server_port)+"]");
connect = network_create_socket(network_socket_tcp);
status = network_connect_raw(connect,server_ip,server_port);
if (status < 0)
    add_debug("Failed to connect to server ["+string(server_ip)+":"+string(server_port)+"]",c_red);

// netgraph
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
    netgraph[i] = 0;
// msg_in, byte_in, msg_out, byte_out