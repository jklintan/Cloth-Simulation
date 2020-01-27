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

    %Properties
    % Number of particles
      m = 0.1; %Mass of particles
    % Stiffness N/m
    % Damping Ns/m
    % ks %Spring constant value
    % kd %Damper constant value

    figure; 
    particles = particlesystem(row, col, 0);
    for c = 1:col
        for r = 1:row
            xlim([0 row+1]);
            ylim([0 col+1]);
            %particles.particles = particles.particles + particle(r,c,m, false);
            plot(r, c, 'r*-', 'LineWidth', 2);
            hold on;
        end
    end

end

%%

