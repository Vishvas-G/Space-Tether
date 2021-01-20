function dstate=orbit(t,state);
planet
m_v=25000;
m_s=50;

global tether_s;
global tether_v;
 
rs=state(1:3);
rv=state(4:6);
vs=state(7:9);
vv=state(10:12);

rs_norm=norm(rs);
rs_hat=rs/rs_norm;

rv_norm=norm(rv);
rv_hat=rv/rv_norm;

vs_norm=norm(vs);
vv_norm=norm(vv);

rhat=rs-rv;
rhat=rhat/norm(rhat);

Fs_gav=-(u*m_s/(rs_norm.^2))*rs_hat;
Ts=(-norm(Fs_gav)+(m_s*(vs_norm.^2)/rs_norm))*(-rs_hat);

Fv_gav=-(u*m_v/(rv_norm.^2))*rv_hat;
Tv=(norm(Fv_gav)-(m_v*(vv_norm.^2)/rv_norm))*(rv_hat);

if t>2.77e+03;
     Ts=0;
     Tv=0;
end

% tether tension model
x=norm(rs-rv)-(tether_s-tether_v);
k=0;  

Fs=Fs_gav+Ts+k*x*(-rhat);
as=Fs/m_s;

Fv=Fv_gav-Tv+k*x*(rhat);
av=Fv/m_v;

dstate=[vs;vv;as;av];
