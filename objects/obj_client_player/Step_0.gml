xprevious = x;
yprevious = y;

x = herm(px[|1],px[|2],mx1,mx2,t);
y = herm(py[|1],py[|2],my1,my2,t);

t += 0.33;
if (t > 1)
	{
	t -= 1;
	
	if (points > 5)
		points--;
	else
		{
		var temp_x = px[|4];
		var temp_y = py[|4];
		ds_list_add(px,temp_x);
		ds_list_add(py,temp_y);
		}
	
	ds_list_delete(px,0);
	ds_list_delete(py,0);
	
	mx1 = (px[|2] - px[|0]) / 2;
	my1 = (py[|2] - py[|0]) / 2;
	mx2 = (px[|3] - px[|1]) / 2;
	my2 = (py[|3] - py[|1]) / 2;
	}