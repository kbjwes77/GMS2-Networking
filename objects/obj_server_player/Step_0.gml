var dt = delta_time / global.dt;

var key_left = (keys & 1);
var key_right = (keys & 2) >> 1;
var key_up = (keys & 4) >> 2;
var key_down = (keys & 8) >> 3;

if (key_right) xor (key_left)
	{
	if (key_left)
		xspeed = max(-3,xspeed - (1 * dt));
	if (key_right)
		xspeed = min(+3,xspeed + (1 * dt));
	}
else
	{
	if (xspeed > 0)
		xspeed = max(0,xspeed-(0.5 * dt));
	else if (xspeed < 0)
		xspeed = min(0,xspeed+(0.5 * dt));
	}
if (key_down) xor (key_up)
	{
	if (key_up)
		yspeed = max(-3,yspeed - (1 * dt));
	if (key_down)
		yspeed = min(+3,yspeed + (1 * dt));
	}
else
	{
	if (yspeed > 0)
		yspeed = max(0,yspeed-(0.5 * dt));
	else if (yspeed < 0)
		yspeed = min(0,yspeed+(0.5 * dt));
	}

if (gen)
	{
	if (xspeed > 0)
		var cx = x+x2;
	else
		var cx = x+x1;
	
	if (yspeed > 0)
		var cy = y+y2;
	else
		var cy = y+y1;
		
	if (ds_grid_get(grid,floor((cx + xspeed*dt)/16),floor((y+y1)/16)) == false) and (ds_grid_get(grid,floor((cx + xspeed*dt)/16),floor((y+y2)/16)) == false)
		x += xspeed*dt;
	else
		{
		var sx = sign(xspeed);
		while((ds_grid_get(grid,floor((cx+sx)/16),floor((y+y1)/16)) == false) and (ds_grid_get(grid,floor((cx+sx)/16),floor((y+y2)/16)) == false))
			{
			x += sx;
			cx += sx;
			}
		xspeed = 0;
		}
	
	if (ds_grid_get(grid,floor((x+x1)/16),floor((cy + yspeed*dt)/16)) == false) and (ds_grid_get(grid,floor((x+x2)/16),floor((cy + yspeed*dt)/16)) == false)
		y += yspeed*dt;
	else
		{
		var sy = sign(yspeed);
		while((ds_grid_get(grid,floor((x+x1)/16),floor((cy+sy)/16)) == false) and (ds_grid_get(grid,floor((x+x2)/16),floor((cy+sy)/16)) == false))
			{
			y += sy;
			cy += sy;
			}
		yspeed = 0;
		}
	}
else if (instance_exists(obj_gen))
	{
	gen = true;
	
	w = obj_gen.w;
	h = obj_gen.h;
	grid = ds_grid_create(w,h);
	ds_grid_copy(grid,obj_gen.grid);
	}