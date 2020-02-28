clear all;
clc;
close('all');

plane_size = [10,10];                %Storleken på planet som ska skapas
z = ones(plane_size(1));            %Test-yta som är fixed (Bra för att prova mesh-funktionen)

length = 5;                       %Simulationstid i sekunder
dt = 0.019;                        %Tidsteg i sekunder
t = 0:dt/length:length;           %Tidssamples
n = numel(t);                     %Antalet tidssamples
m = 20/(plane_size(1).*plane_size(2)); %Partikelmasssa
ks = 200;                         %Fjäderkonstant
kd = 4; 
airRes = 0.2;
plane = point.empty;              %Skapa ett plan
R = 1;
perspective = [-10 10];

for i = 1:plane_size(1)
    for j = 1:plane_size(2)
        plane(i,j) = point(i,j,z(j,i));
    end
end


figure;                           %Öppna figuren
data(1) = plane(4,4).z;

%SIMULERA OCH RENDERA CLOTHEN
for step = 2:n
    plane = forcefield(t,dt,step,plane,ks,kd,R,m, airRes);
    data(step) = plane(4,4).z;
    [X,Y,Z] = bindGrid(plane,plane_size);
    mesh(X,Y,Z);
    xlim(perspective);
    ylim(perspective);
    zlim(perspective);
    drawnow;
    %pause(0.01);
end

 figure;
   
   plot(t,data);
   xlabel('Time (s)');
   ylabel('Position for z axis (m)');
   title('Step response with stable values with Implicit Euler');