clear;
clc;

size = 50;                  %Storleken på planet som ska skapas
plane = ones(size);         %Skapa planet

length = 0.1;               %Simulationstid i sekunder
dt = 0.000005;              %Tidsteg i sekunder
t = 0:dt/length:length;     %Tidssamples
n = numel(t);               %Antalet tidssamples
m = 1/size;                 %Partikelmasssa
K = 2000;                   %Fjäderkonstant
 
%z = peaks(25);             %Test-yta som är fixed (Bra för att prova mesh-funktionen)
 

figure;                     %Öppna figuren

for step = 2:n
    plane = forcefield(step,plane,K,m);
    mesh(plane);
    zlim([-8 8]);
    drawnow;
    pause(0.001);
end

