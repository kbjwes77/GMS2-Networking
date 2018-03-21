server = instance_exists(obj_server);

random_set_seed(global.gen_seed);

tile_list = ds_list_create();
tiles = 0;

var xmin = +1000; var ymin = +1000;
var xmax = -1000; var ymax = -1000;
for(var i=0; i<12; i++;)
	{
	var xpos = 0;
	var ypos = 0;
	var dir = irandom(3);
	var len = 16+irandom(48);
	
	for(var j=0; j<len; j++;)
		{
		var found = false;
		for(var k=0; k<tiles; k++;)
			{
			temp_x = tile_list[|k*2 + 0];
			temp_y = tile_list[|k*2 + 1];
			
			if (temp_x == xpos) and (temp_y == ypos)
				found = true;
			}
		
		if !(found)
			{
			ds_list_add(tile_list,xpos,ypos);
			tiles++;
			}
		
		xpos += lengthdir_x(1,dir*90);
		ypos += lengthdir_y(1,dir*90);
		if (xpos-1 < xmin)
			xmin = xpos-1;
		else if (xpos+1 > xmax)
			xmax = xpos+1;
		if (ypos-1 < ymin)
			ymin = ypos-1;
		else if (ypos+1 > ymax)
			ymax = ypos+1;
		
		if (random(1) < 0.4)
			{
			dir += choose(-1,0,1);
			if (dir < 0)
				dir = 3;
			if (dir > 3)
				dir = 0;
			}
		}
	}

xadd = abs(xmin);
yadd = abs(ymin);

w = (xmax - xmin)+1;
h = (ymax - ymin)+1;
grid = ds_grid_create(w,h);
ds_grid_clear(grid,true);

if !(server)
	{
	wall_layer = layer_create(256);
	floor_layer = layer_create(128);
	tilemap_walls = layer_tilemap_create(wall_layer,0,0,til_wall_tileset,w,h);
	tilemap_floors = layer_tilemap_create(floor_layer,0,0,til_floor_tileset,w,h);

	tilemap_clear(tilemap_walls,0);
	tilemap_clear(tilemap_floors,0);
	}

for(var i=0; i<tiles; i++;)
	{
	var xpos = tile_list[|i*2 + 0];
	var ypos = tile_list[|i*2 + 1];
	xpos += xadd;
	ypos += yadd;
	
	ds_grid_set(grid,xpos,ypos,false);
	
	if !(server)
		{
		tilemap_set(tilemap_floors,1,xpos,ypos);
		if (xpos+1 < w) and (tilemap_get(tilemap_walls,xpos+1,ypos+0) == 0)
			tilemap_set(tilemap_walls,1,xpos+1,ypos+0);
		if (xpos+1 < w) and (ypos-1 >= 0) and (tilemap_get(tilemap_walls,xpos+1,ypos-1) == 0)
			tilemap_set(tilemap_walls,1,xpos+1,ypos-1);
		if (ypos-1 >= 0) and (tilemap_get(tilemap_walls,xpos+0,ypos-1) == 0)
			tilemap_set(tilemap_walls,1,xpos+0,ypos-1);
		if (xpos-1 >= 0) and (ypos-1 >= 0) and (tilemap_get(tilemap_walls,xpos-1,ypos-1) == 0)
			tilemap_set(tilemap_walls,1,xpos-1,ypos-1);
		if (xpos-1 >= 0) and (tilemap_get(tilemap_walls,xpos-1,ypos+0) == 0)
			tilemap_set(tilemap_walls,1,xpos-1,ypos+0);
		if (xpos-1 >= 0) and (ypos+1 < h) and (tilemap_get(tilemap_walls,xpos-1,ypos+1) == 0)
			tilemap_set(tilemap_walls,1,xpos-1,ypos+1);
		if (ypos+1 < h) and (tilemap_get(tilemap_walls,xpos+0,ypos+1) == 0)
			tilemap_set(tilemap_walls,1,xpos+0,ypos+1);
		if (xpos+1 < w) and (ypos+1 < h) and (tilemap_get(tilemap_walls,xpos+1,ypos+1) == 0)
			tilemap_set(tilemap_walls,1,xpos+1,ypos+1);
		}
	}

ds_list_destroy(tile_list);

if (server)
	{
	spawn_x = 0;
	spawn_y = 0;
	while(ds_grid_get(grid,spawn_x,spawn_y) == 1)
		{
		spawn_x = irandom(w-1);
		spawn_y = irandom(h-1);
		}
	}