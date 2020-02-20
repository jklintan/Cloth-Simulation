%% Cloth simulation

%% About

%This program is a simulation of a cloth based on a
%mass-spring-damper method.

%Created by Josefine Klintberg, Julius Halldan, Olivia Enroth, Elin
%Karlsson

%Based on the code by Auralius Manurung, Copyright (c) 2016, All rights reserved.

%Requires navigation toolbox and database toolbox for node handling

%% Reset

close all; clc; clear all;

%% Main simulation, variables

PlotWindow.f = figure;
PlotWindow.a = axes;
PlotWindow.h = plot(0, 0);

xlabel('meter');
ylabel('meter');

% Parameters, note that stiffness > damping > mass
sim = 1; %1 = top row, 2 = one point, 3 = table
method = 2; %1 = Euler, 2 = Verlet

row =10;
col = 20;
ts = 0.001;              % Seconds
timelim = 10000;
distanceNodes = 0.02;    % Meter
stiffness = 20;           % N/m
damping = 4;            % Ns/m
mass = 0.2;              % Kg

%% Set properties

if(sim == 1)
    stiffness = 40;           % N/m
    damping = 12;            % Ns/m
end

if(sim == 2)
    col = 8;
    row = 8;
    stiffness = 90;           % N/m 
    damping = 15;            % Ns/m 
    m = 0.08;
end

if(sim == 3)
    col = 10;
    stiffness = 20;           % N/m
    damping = 4;            % Ns/m
    mass = 0.2;              % Kg
end

%%  Build the nodes and the canvas
nodes.row = row;
nodes.col = col;

for c = 1: col
    for r = 1 : row
        node(r,c).initalPos = [(c - 1)*distanceNodes (r - 1)*distanceNodes ]; 
        node(r,c).pos = node(r,c).initalPos;
        node(r,c).pos_old = node(r,c).pos; % Used for Verlet integration
        node(r,c).acc = [0 0];
        node(r,c).vel = [0 0];
        node(r,c).force_ext = [0 0];
        
        if(sim == 1)
            if (r == 1)
                node(r,c).isFixed = 1;
            else
                node(r,c).isFixed = 0;
            end
        end
        
        % Set only one point
        if(sim == 2)
            if (r == 1 && c == 1)
                node(r,c).isFixed = 1;
            else
                node(r,c).isFixed = 0;
            end
        end

        % Set middle square as fixed
        if(sim == 3)
            if ((r <= floor(row/2)+3 && r >= floor(row/2)-3 ) && (c <= floor(col/2)+3 && c >= floor(col/2)-2 ))
                  node(r,c).isFixed = 1;
            else
                node(r,c).isFixed = 0;
            end
        end

    end
end

nodes.node = node;

% Create the plot window
i = 1;
for c = 1 : nodes.col
    for r = 1 : nodes.row
        plot(i,:) = nodes.node(r, c).pos;
        i = i + 1;
    end
end

canvas_min = min(plot);
canvas_max = max(plot);
range = canvas_max - canvas_min;

xlim([canvas_min(1)-range(1) canvas_max(1)+range(1)])
if(sim == 1)
    ylim([canvas_min(2)-range(2)*nodes.row canvas_max(2)])
elseif(sim == 2)
    ylim([-1.5 canvas_max(2)]) %For fixed middle
elseif(sim == 3)
    ylim([-0.4 0.4]) %For fixed square
end

lattice = drawNodes(PlotWindow, plot, nodes, 0);

%% Main loop
for i = 0 : timelim

    %Update the position of the nodes
    nodes = updateNode(nodes, mass, stiffness, damping, ts, method);
    
    %Draw the nodes in the plot
    lattice = drawNodes(PlotWindow, lattice, nodes, ts);
end

%% Draw the nodes
function plot = drawNodes(PlotWindow, plot, nodes, timestep)
i = 1;

for c = 1 : nodes.col
    for r = nodes.row : -1 : 1
        plot(i, :) = nodes.node(r, c).pos;
        i = i + 1;
    end
    
    for r = 1 : nodes.row
        plot(i,:) = nodes.node(r,c).pos;
        i = i + 1;
        if (c < nodes.col)
            plot(i ,:) = nodes.node(r, c + 1).pos;
            i = i + 1;
        end
    end   
end

set(PlotWindow.h, 'XData', plot(:,1));
set(PlotWindow.h, 'YData', plot(:,2));

drawnow;
end


%% Update the position of each node

function nodes = updateNode(nodes, mass, stiffness, damping, ts, method)

    row = nodes.row;
    col = nodes.col;
    node = nodes.node;

    % Go through lattice
    for r = 1 : row    
        for c = 1 : col
            
            % Forces and initial length
            fs = [0 0];
            fb = [0 0];
            f_gravity = mass * [0 -9.81];
            f_air = [0 0];
            
            % Update forces for 4-neighbours (stretching forces)
            % Update forces for 8-neighbours (shearing forces)
            % Spring force according to Hook's law 
            % Damping force according to linear damping of velocity
            
            % Mass to the left
            if (c > 1)
                L = norm(node(r, c).initalPos - node(r, c-1).initalPos);                        
                xij = node(r, c).pos - node(r, c-1).pos; 
                norm_xij = norm(xij, 2);
                fs = fs + (-stiffness * (norm_xij - L) * xij / norm_xij);
                fb = fb + (-damping*(node(r, c).vel - node(r, c-1).vel));
            end
            
            % Mass above
            if (r > 1)
                L = norm(node(r, c).initalPos - node(r-1, c).initalPos);
                xij = node(r, c).pos - node(r-1, c).pos;
                norm_xij = norm(xij, 2);
                fs = fs + (-stiffness * (norm_xij - L) * xij / norm_xij);
                fb = fb + (-damping*(node(r, c).vel - node(r-1, c).vel));
            end
            
            % Mass below
            if (r < row)
                L = norm(node(r, c).initalPos - node(r+1, c).initalPos);
                xij = node(r, c).pos - node(r+1, c).pos;
                norm_xij = norm(xij);
                fs = fs + (-stiffness * (norm_xij - L) * xij / norm_xij);
                fb = fb + ( -damping*(node(r, c).vel - node(r+1, c).vel));
            end

            % Mass to the right
            if (c < col)
                L = norm(node(r, c).initalPos - node(r, c+1).initalPos);
                xij = node(r, c).pos - node(r, c+1).pos;
                norm_xij = norm(xij, 2);
                fs = fs + (-stiffness * (norm_xij - L) * xij / norm_xij);
                fb = fb + (-damping*(node(r, c).vel - node(r, c+1).vel));
            end
            
            % Mass diagonal, down left
            if (r < row && c > 1)
                L = norm(node(r, c).initalPos - node(r+1, c-1).initalPos);
                xij = node(r, c).pos - node(r+1, c-1).pos;
                norm_xij = norm(xij);        
                fs = fs + (-stiffness * (norm_xij - L) * xij / norm_xij);
                fb = fb + (-damping*(node(r, c).vel - node(r+1, c-1).vel));
            end

            % Mass diagonal, top right
            if (r > 1 && c < col)
                L = norm(node(r, c).initalPos - node(r-1, c+1).initalPos);
                xij = node(r, c).pos - node(r-1, c+1).pos;
                norm_xij = norm(xij, 2);
                fs = fs + (-stiffness * (norm_xij - L) * xij / norm_xij);
                fb = fb + (-damping*(node(r, c).vel - node(r-1, c+1).vel));
            end
            
            % Mass diagonal, down right
            if (r < row && c < col)
                L = norm(node(r, c).initalPos - node(r+1, c+1).initalPos);                        
                xij = node(r, c).pos - node(r+1, c+1).pos; 
                norm_xij = norm(xij, 2);
                fs = fs + (-stiffness * (norm_xij - L) * xij / norm_xij);
                fb = fb + (-damping*(node(r, c).vel - node(r+1, c+1).vel));
            end
            
            % Mass diagonal, top left
            if (r > 1 && c > 1)
                L = norm(node(r, c).initalPos - node(r-1, c-1).initalPos);                        
                xij = node(r, c).pos - node(r-1, c-1).pos; 
                norm_xij = norm(xij, 2);
                fs = fs + (-stiffness * (norm_xij - L) * xij / norm_xij);
                fb = fb + (-damping*(node(r, c).vel - node(r-1, c-1).vel));
            end
            
            % External forces
            f_air = 0.2 * node(r,c).vel;
            
            % Add spring forces, damping forces and gravity together
            node(r,c).force =  fs + fb + f_gravity - f_air;
        end
    end

    % Position, velocity, and accelleration update for all nodes
    for r = 1 : row        
        for c = 1: col
            if  node(r,c).isFixed ~= 1  % Upate all nodes except the fixed ones          
                node(r,c).acc = node(r,c).force ./ mass;
                
                % Euler method for updating position and velocity
                if(method == 1)
                    node(r,c).vel = Euler(node(r,c).vel, node(r,c).acc, ts);
                    node(r,c).pos = Euler(node(r,c).pos, node(r,c).vel, ts); 
                else
                    % Verlet method for updating position and velocity
                    [node(r,c).pos_old, node(r,c).pos, node(r,c).vel] = Verlet(node(r,c).pos, node(r,c).pos_old, node(r,c).acc, ts);
            
                end
            end
        end
    end
    
    nodes.node = node;
end

%% Euler method

function xtNext = Euler(xt, xtPrim,h)
    xtNext = xt + h*xtPrim;
end


%% Verlet method

% Position and velocity update
function [xtLast, xtNext, vtNext] = Verlet(xt, xtPrev, xtPrimPrim, h)
    xtLast = xt;
    xtNext = 2*xt - xtPrev + h^2*xtPrimPrim;
    vtNext = 1/(2*h) * (xtNext - xt);
end
