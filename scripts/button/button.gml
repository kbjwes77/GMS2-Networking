/// button(x,y,text);

var x1 = argument[0];
var y1 = argument[1];
var sw = string_width(argument[2])+12;
var sh = string_height(argument[2])+8;

draw_set_halign(1);
draw_set_valign(1);

if (point_in_rectangle(mouse_x,mouse_y,x1 - sw/2,y1 - sh/2,x1 + sw/2,y1 + sh/2))
	{
	draw_set_color($FFFFFF);
	draw_rectangle(x1 - sw/2,y1 - sh/2,x1 + sw/2,y1 + sh/2,0);
	draw_set_color($000000);
	draw_text(x1,y1,argument[2]);
	
	draw_set_halign(0);
	draw_set_valign(0);
	
	if (mouse_check_button_pressed(mb_left))
		return(true);
	}
else
	{
	draw_set_color($FFFFFF);
	draw_rectangle(x1 - sw/2,y1 - sh/2,x1 + sw/2,y1 + sh/2,1);
	draw_text(x1,y1,argument[2]);
	
	draw_set_halign(0);
	draw_set_valign(0);
	}

return(false);