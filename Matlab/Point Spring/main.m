clear;
clc;

plane_size = [10,10];                  %Storleken på planet som ska skapas
z = peaks(plane_size);            %Test-yta som är fixed (Bra för att prova mesh-funktionen)

length = 1;                       %Simulationstid i sekunder
dt = 0.01;                        %Tidsteg i sekunder
%dt = 0.1;
t = 0:dt/length:length;           %Tidssamples
n = numel(t);                     %Antalet tidssamples
m = 1/plane_size;                 %Partikelmasssa
K = 2000;                         %Fjäderkonstant
plane = point.empty;              %Skapa ett plan

for i = 1:plane_size(1)
    for j = 1:plane_size(2)
        plane(i,j).x = i;
        plane(i,j).y = j;
        plane(i,j).z = z(i,j);
    end
end


figure;                           %Öppna figuren

%SIMULERA OCH RENDERA CLOTHEN
for step = 2:n
    plane = forcefield(step,plane,K,m);
    [X,Y,Z] = bindGrid(plane,plane_size);
    mesh(X,Y,Z);
    xlim([0 plane_size]);
    ylim([0 plane_size]);
    zlim([-8 8]);
    drawnow;
    %pause(0.01);
end


