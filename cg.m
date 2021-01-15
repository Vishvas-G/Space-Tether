function state_cg=cg(t,state)
 

planet

r=state(1:3);
v=state(4:6);

rnorm=norm(r);
rhat=r/rnorm;

a=-(u/(rnorm.^2))*rhat;
%a=F/m;
state_cg=[v;a];