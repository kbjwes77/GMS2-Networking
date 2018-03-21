var vw = 800;
var vh = 600;

draw_set_font(fnt_default);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
if (button(400,300 - 40,"host"))
	{
	instance_create_depth(0,0,0,obj_server);
	instance_destroy();
	}
if (button(vw/2,vh/2 + 40,"join"))
	{
	instance_create_depth(0,0,0,obj_client);
	instance_destroy();	
	}
draw_set_halign(fa_left);
draw_set_valign(fa_top);