%% Cloth simulation

%% About 

%This program is a simulation of a cloth based on a 
%mass-spring-damper method. 

%% Reset

close all; clc; close all;

%% Main function

row = 5;
col = 5;
timestep = 0.01;

cloth(row, col, timestep);

%% Cloth function

function cloth(row, col, timestep)
% 
%     Properties
%     Number of particles
%       m = 0.1; %Mass of particles
%     Stiffness N/m
%     Damping Ns/m
%     ks %Spring constant value
%     kd %Damper constant value
    
v1= [0, 1];
v2= [1 , 0];
[x,y] = meshgrid(0:10,0:5);
xy = [x(:),y(:)];
T = [v1;v2];
xyt = xy*T;
xt = reshape(xyt(:,1),size(x));
yt = reshape(xyt(:,2),size(y));
plot(xt,yt,'r-')
hold on
plot(xt',yt','r-')
axis equal
axis square


for t = 1:100
    clf;
    yt = yt - 0.01*t; %update position for masses
    plot(xt,yt,'bo-');
    hold on;
    plot(xt', yt', 'r-');
    xlim([-5 10]);
    ylim([-10 10]);
    drawnow;
end


end

%%

