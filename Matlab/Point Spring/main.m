clear all;
clc;
close('all');

plane_size = [10,10];                %Storleken på planet som ska skapas
z = ones(plane_size(1));            %Test-yta som är fixed (Bra för att prova mesh-funktionen)

length = 5;                       %Simulationstid i sekunder
dt = 0.005;                        %Tidsteg i sekunder
t = 0:dt/length:length;           %Tidssamples
n = numel(t);                     %Antalet tidssamples
m = 20/plane_size(1);              %Partikelmasssa
ks = 2000;                         %Fjäderkonstant
kd = 8; 
plane = point.empty;              %Skapa ett plan
R = 1;
perspective = [-10 10];

for i = 1:plane_size(1)
    for j = 1:plane_size(2)
        plane(i,j) = point(i,j,z(j,i));
    end
end


figure;                           %Öppna figuren

%SIMULERA OCH RENDERA CLOTHEN
for step = 2:n
    plane = forcefield(t,dt,step,plane,ks,kd,R,m);
    [X,Y,Z] = bindGrid(plane,plane_size);
    mesh(X,Y,Z);
    xlim(perspective);
    ylim(perspective);
    zlim(perspective);
    drawnow;
    %pause(0.01);
end

