%simulation of low earth sattelite
clear;
clc;

planet

global rt_hat;
global timespan;
global tether_s;
global tether_v;
%initial conditions
m_s=50; %mass of spacecraft in kg
m_v=25000;


altitude=408*1000; % in meters
x0=R+altitude;
y0=0;
z0=0;
semimajor=norm([x0;y0;z0]);
inclination=0;
Vcirc=sqrt(u/(semimajor));

tether_s=50000;
tether_v=-(tether_s*m_s)/m_v;

xdot0=0;
ydot0=(Vcirc)*cos(inclination);
zdot0=(Vcirc)*sin(inclination);

state_s=[x0+tether_s;y0;z0];
semimajor_s=norm(state_s);
xdot_s=0;
ydot_s=(Vcirc*(semimajor_s/semimajor))*cos(inclination);
zdot_s=(Vcirc*(semimajor_s/semimajor))*sin(inclination);

state_v=[x0+tether_v;y0;z0];
semimajor_v=norm(state_v);
xdot_v=0;
ydot_v=(Vcirc*(semimajor_v/semimajor))*cos(inclination);
zdot_v=(Vcirc*(semimajor_v/semimajor))*sin(inclination);


%timespan
orbitcount=2.5;
period=2*pi*sqrt(semimajor.^3/u);
timespan=0:5:orbitcount*period;
Ts=zeros([length(timespan) 1]);
Tv=zeros([length(timespan) 1]);
w0=2*pi/period;

initialstate_s=[x0+tether_s;y0;z0;xdot0;ydot0+tether_s*w0;zdot0;];
initialstate_v=[x0+tether_v;y0;z0;xdot0;ydot0+tether_v*w0;zdot0;];
initialstate_cg=[x0;y0;z0;xdot0;ydot0;zdot0;];
initialstate=[x0+tether_s;y0;z0;x0+tether_v;y0;z0;xdot_s;ydot_s;zdot_s;xdot_v;ydot_v;zdot_v;];
rs_hat=initialstate_s/norm(initialstate_s);
rv_hat=initialstate_v/norm(initialstate_v);
rt_hat=rs_hat-rv_hat;
rt_hat=rt_hat/norm(rt_hat);


% %ode45 solution
% [t_s,state_s] = ode45(@satellite,timespan,initialstate_s);
% [t_v,state_v] = ode45(@vehicle,timespan,initialstate_v);
%[t_cg,state_cg] = ode45(@cg,timespan,initialstate_cg);
[t,state]=ode45(@orbit,timespan,initialstate);

%earth model
[p1,p2,p3]=sphere;
p1=p1*R/1000;
p2=p2*R/1000;
p3=p3*R/1000;

%plotting
s1=state(:,1)/1000;
s2=state(:,2)/1000;
s3=state(:,3)/1000;

v1=state(:,4)/1000;
v2=state(:,5)/1000;
v3=state(:,6)/1000;

% cg1=state_cg(:,1)/1000;
% cg2=state_cg(:,2)/1000;
% cg3=state_cg(:,3)/1000;

U=s1-v1;
V=s2-v2;
W=s3-v3;

world=imread('world4.jpg');
imshow(world)


hold on

for k=1:length(t);
    %set(gca,'color',0.4*[1,1,1]);
    axis(8400*[-1,1,-1,1,-1,1]);
    hold on
    grid on
    view([-90,90]);
    %view([-1,1,1]);
    
    

    surf(p1,p2,-p3,'EdgeColor','none');
    h=findobj('Type','surface');
    set(h,'CData',world,'FaceColor','texturemap')


    plot3(s1(k),s2(k),s3(k),'r.','MarkerSize',15);
    plot3(v1(k),v2(k),v3(k),'b.','MarkerSize',25);
    %plot3(cg1(k),cg2(k),cg3(k),'k.');

    plot3(s1(1:k),s2(1:k),s3(1:k),'r-','LineWidth',0.5);
    plot3(v1(1:k),v2(1:k),v3(1:k),'b-','LineWidth',0.5);
    %plot3(cg1(1:k),cg2(1:k),cg3(1:k),'k-');
    

    if k<length(t)/4;
        quiver3(v1(k),v2(k),v3(k),U(k),V(k),W(k),'k');
    end
    %campos([s1(k),s2(k),s3(k)]);
    %camtarget([-s1(k),-s2(k),-s3(k)]);
    %F(k)=getframe(gcf);
    pause(0.01);
    if k<length(t);
        clf
    end
end


% video = VideoWriter('Space_tether2d1.mp4','MPEG-4');
% video.FrameRate=60;
% open(video)
% writeVideo(video,F);
% close(video)




