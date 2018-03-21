/// herm(p0,p1,m0,m1,t);
/// @function herm
/// @arg p0
/// @arg p1
/// @arg m0
/// @arg m1
/// @arg t

var t1 = argument[4];
var t2 = sqr(t1);
var t3 = t1*t2;

return(argument[0]*(2*t3 - 3*t2 + 1) + argument[2]*(t3 - 2*t2 + t1) + argument[1]*(-2*t3 + 3*t2) + argument[3]*(t3-t2));