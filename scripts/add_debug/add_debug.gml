/// @description  add_debug(str,?col);
/// @function  add_debug
/// @param str
/// @param ?col

show_debug_message(argument[0]);
ds_list_insert(debug_list,0,argument[0]);

if (argument_count > 1)
    ds_list_insert(debug_list,0,argument[1]);
else
    ds_list_insert(debug_list,0,c_ltgray);

while(ds_list_size(debug_list) > 10*2)
    ds_list_delete(debug_list,ds_list_size(debug_list)-1);
