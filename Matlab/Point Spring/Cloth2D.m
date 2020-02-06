%% Cloth simulation

%% About

%This program is a simulation of a cloth based on a
%mass-spring-damper method.

%Created by Josefine Klintberg, Julius Halldan, Olivia Enroth, Elin
%Karlsson

%Based on the code by Auralius Manurung
%Copyright (c) 2016, All rights reserved.

%Requires navigation toolbox and database toolbox

%% Reset

close all; clc; clear all;

%% Main simulation

S.f = figure;
S.a = axes;
S.h = plot(0, 0);
%S.mText = uicontrol('style','text');

xlabel('meter');
ylabel('meter');

% Parameters, note that stiffness > damping > mass
% Euler 40, 8, 0.1
sim = 3; %1 = top row, 2 = one point, 3 = table
method = 2; %1 = Euler, 2 = Verlet


row =10;
col = 20;
ts = 0.001;              % Seconds
timelim = 10000;
distanceNodes = 0.02;    % Meter
stiffness = 20;           % N/m
damping = 4;            % Ns/m
mass = 0.2;              % Kg

if(sim == 1)
    stiffness = 40;           % N/m
    damping = 12;            % Ns/m
end

if(sim == 2)
    col = 8;
    row = 8;
    stiffness = 80;           % N/m 
    damping = 12;            % Ns/m %For showcase, use damping 2 and show spring force
    m = 0.08;
end

if(sim == 3)
    col = 10;
    stiffness = 20;           % N/m
    damping = 4;            % Ns/m
    mass = 0.2;              % Kg
end



% Build the nodes and the canvas
nodes.row = row;
nodes.col = col;

for c = 1: col
    for r = 1 : row
        node(r,c).initalPos = [(c - 1)*distanceNodes (r - 1)*distanceNodes ]; % 1 cm step
        node(r,c).pos = node(r,c).initalPos;
        node(r,c).pos_old = node(r,c).pos; % Used for Verlet integration
        node(r,c).acc = [0 0];
        node(r,c).vel = [0 0];
        node(r,c).force_ext = [0 0];
        
        % Set middle as fixed
        %if (r == floor(row/2) && c == floor(col/2))
        %    node(r,c).isFixed = 1;
        % Set top row as fixed
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

        % Set corners as fixed
        %if (r == 1 && c == 1 || (r == 1 && c == col) || (r == row && c == 1) || (r == row && c == col) )
        %   node(r,c).isFixed = 1;

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
%view([0 -0.2 0.2])
plotwindow = drawNodes(S, plot, nodes, 0);

% Main loop
for i = 0 : timelim

    %Update the position of the nodes
    nodes = updateNode(nodes, mass, stiffness, damping, ts, method);
    
    %Draw the nodes in the plot
    plotwindow = drawNodes(S, plotwindow, nodes, ts);
end

%% Draw the nodes
function plot = drawNodes(S, plot, nodes, timestep)
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

set(S.h, 'XData', plot(:,1));
set(S.h, 'YData', plot(:,2));

drawnow;
end

%% Build the nodes

function nodes = buildNodes(row, col)

nodes.row = row;
nodes.col = col;

for c = 1: col
    for r = 1 : row
        node(r,c).initalPos = [(c - 1) / 100 (r - 1) / 100 ]; % 1 cm step
        node(r,c).pos = node(r,c).initalPos;
        node(r,c).pos_old = node(r,c).pos;
        node(r,c).acc = [0 0];
        node(r,c).vel = [0 0];
        node(r,c).force_ext = [0 0];
        
        % Set top row as fixed
        if (r == 1)
            node(r,c).isFixed = 1;
        % Set middle row as fixed
        %if (r == floor(row/2))
        %    node(r,c).isFixed = 1;
        % Set top two corners as fixed
        %if (r == 1 && c == 1 || (r == 1 && c == col) )
        %   node(r,c).isFixed = 1;
        else
            node(r,c).isFixed = 0;
        end
    end
end

nodes.node = node;
end

%% Update the position of each node

function nodes = updateNode(nodes, mass, stiffness, damping, ts, method)

    row = nodes.row;
    col = nodes.col;
    node = nodes.node;

    for r = 1 : row
        nextRow = r + 1;
        prevRow = r - 1;
        
        for c = 1 : col
            nextCol = c + 1;
            prevCol = c - 1;
            
            % Stiffnes forces
            fs1 = [0 0];
            fs2 = [0 0];
            fs3 = [0 0];
            fs4 = [0 0];
            fs5 = [0 0];
            fs6 = [0 0];
            fs7 = [0 0];
            fs8 = [0 0];
            
            % Damping forces
            fb1 = [0 0];
            fb2 = [0 0];
            fb3 = [0 0];
            fb4 = [0 0];
            fb5 = [0 0];
            fb6 = [0 0];
            fb7 = [0 0];
            fb8 = [0 0];
           
            L = 10; % Initial link
            
            % Link 1
            if (r < row && c > 1)
                L = norm(node(r, c).initalPos - node(nextRow, prevCol).initalPos);
                xij = node(r, c).pos - node(nextRow, prevCol).pos;
                norm_xij = norm(xij);                
                fs1 = -stiffness * (norm_xij - L) * xij / norm_xij;
                fb1 = -damping*(node(r, c).vel - node(nextRow, prevCol).vel);
            end

            % Link 2
            if (r < row)
                L = norm(node(r, c).initalPos - node(nextRow, c).initalPos);
                xij = node(r, c).pos - node(nextRow, c).pos;
                norm_xij = norm(xij);
                fs2 = -stiffness * (norm_xij - L) * xij / norm_xij;
                fb2 = -damping*(node(r, c).vel - node(nextRow, c).vel);
            end

            % Link 3
            if (c < col)
                L = norm(node(r, c).initalPos - node(r, nextCol).initalPos);
                xij = node(r, c).pos - node(r, nextCol).pos;
                norm_xij = norm(xij, 2);
                fs3 = -stiffness * (norm_xij - L) * xij / norm_xij;
                fb3 = -damping*(node(r, c).vel - node(r, nextCol).vel);
            end

            % Link 4
            if (r > 1 && c < col)
                L = norm(node(r, c).initalPos - node(prevRow, nextCol).initalPos);
                xij = node(r, c).pos - node(prevRow, nextCol).pos;
                norm_xij = norm(xij, 2);
                fs4 = -stiffness * (norm_xij - L) * xij / norm_xij;
                fb4 = -damping*(node(r, c).vel - node(prevRow, nextCol).vel);
            end

            % Link 5
            if (r > 1)
                L = norm(node(r, c).initalPos - node(prevRow, c).initalPos);
                xij = node(r, c).pos - node(prevRow, c).pos;
                norm_xij = norm(xij, 2);
                fs5 = -stiffness * (norm_xij - L) * xij / norm_xij;
                fb5 = -damping*(node(r, c).vel - node(prevRow, c).vel);
            end

            % Link 6
            if (c > 1)
                L = norm(node(r, c).initalPos - node(r, prevCol).initalPos);                        
                xij = node(r, c).pos - node(r, prevCol).pos; 
                norm_xij = norm(xij, 2);
                fs6 = -stiffness * (norm_xij - L) * xij / norm_xij;
                fb6 = -damping*(node(r, c).vel - node(r, prevCol).vel);
            end
            
            % Link 7
            if (r < row && c < col)
                L = norm(node(r, c).initalPos - node(nextRow, nextCol).initalPos);                        
                xij = node(r, c).pos - node(nextRow, nextCol).pos; 
                norm_xij = norm(xij, 2);
                fs7 = -stiffness * (norm_xij - L) * xij / norm_xij;
                fb7 = -damping*(node(r, c).vel - node(nextRow, nextCol).vel);
            end
            
            % Link 8
            if (r > 1 && c > 1)
                L = norm(node(r, c).initalPos - node(prevRow, prevCol).initalPos);                        
                xij = node(r, c).pos - node(prevRow, prevCol).pos; 
                norm_xij = norm(xij, 2);
                fs8 = -stiffness * (norm_xij - L) * xij / norm_xij;
                fb8 = -damping*(node(r, c).vel - node(prevRow, prevCol).vel);
            end

            node(r,c).force =  fs1 + fs2 + fs3 + fs4 + fs5 + fs6 + fs7 + fs8 + ...
                               (fb1 + fb2 + fb3 + fb4 + fb5 + fb6 + fb7 + fb8) + ...
                               mass * [0 -9.81] ...
                               - node(r,c).force_ext;
            %disp(node(r,c).force)

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

%% Euler function

function xtNext = Euler(xt, xtPrim,h)
    xtNext = xt + h*xtPrim;
end


%% Verlet function

% Position and velocity update
function [xtLast, xtNext, vtNext] = Verlet(xt, xtPrev, xtPrimPrim, h)
    xtLast = xt;
    xtNext = 2*xt - xtPrev + h^2*xtPrimPrim;
    vtNext = 1/(2*h) * (xtNext - xt);
end
