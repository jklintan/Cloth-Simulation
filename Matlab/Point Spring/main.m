clear;
clc;
close('all');

plane_size = [10,10];                %Storleken på planet som ska skapas
z = peaks(plane_size(1));            %Test-yta som är fixed (Bra för att prova mesh-funktionen)

length = 1;                       %Simulationstid i sekunder
dt = 0.01;                        %Tidsteg i sekunder
%dt = 0.1;
t = 0:dt/length:length;           %Tidssamples
n = numel(t);                     %Antalet tidssamples
m = 1/plane_size(1);              %Partikelmasssa
ks = 2000;                         %Fjäderkonstant
kd = ks/10; 
plane = point.empty;              %Skapa ett plan
R = 1;


for i = 1:plane_size(1)
    for j = 1:plane_size(2)
        plane(i,j) = point(i,j,z(j,i));
    end
end


figure;                           %Öppna figuren

%SIMULERA OCH RENDERA CLOTHEN
for step = 2:n
    plane = forcefield(t,step,plane,ks,kd,R,m);
    [X,Y,Z] = bindGrid(plane,plane_size);
    mesh(X,Y,Z);
    xlim([0 plane_size(1)]);
    ylim([0 plane_size(2)]);
    zlim([-8 8]);
    drawnow;
    %pause(0.01);
end

