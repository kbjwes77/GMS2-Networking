global.host = false;

view_camera[0] = camera_create();
var viewmat = matrix_build_lookat(400,300,-10,400,300,0,0,1,0);
var projmat = matrix_build_projection_ortho(800,600,1,32000);
camera_set_view_mat(view_camera[0],viewmat);
camera_set_proj_mat(view_camera[0],projmat);