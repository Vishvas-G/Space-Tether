function state_s=satellite(t,state)


m_s=50; 

planet

r=state(1:3);
v=state(4:6);
vnorm=norm(v);

rnorm=norm(r);
rhat=r/rnorm;

Fgav=-(u*m_s/(rnorm.^2))*rhat;
T=Fgav+(m_s*(vnorm.^2)/rnorm)*(rhat);

if t>2.77e+03;
    T=0;
end

F=Fgav-T;
a=F/m_s;
state_s=[v;a];
end

