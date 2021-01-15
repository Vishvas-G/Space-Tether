function state_v=vehicle(t,state)
m_v=25000; %orbiter mass 

planet

r=state(1:3);
v=state(4:6);
vnorm=norm(v);

rnorm=norm(r);
rhat=r/rnorm;

Fgav=-(u*m_v/(rnorm.^2))*rhat;
T=Fgav+(m_v*(vnorm.^2)/rnorm)*(rhat);

if t>2.77e+03;
    T=0;
end

F=Fgav-T;
a=F/m_v;
state_v=[v;a];
