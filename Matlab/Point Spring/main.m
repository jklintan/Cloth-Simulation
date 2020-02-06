%% Cloth simulation

%% About

%This program is a simulation of a cloth based on a
%mass-spring-damper method.

%Based on the code by Auralius Manurung
%Copyright (c) 2016, All rights reserved.

% Requires navigation toolbox and database toolbox for nodes

%% Reset

close all; clc; close all;

%% Main simulation

S.f = figure;
S.a = axes;
S.h = plot(0, 0);
S.mText = uicontrol('style','text');

xlabel('meter');
ylabel('meter');

% Parameters, note that stiffness > damping > mass
row = 5;
col = 10;
stiffness = 40;           % N/m
damping =   8;            % Ns/m
mass = 0.1;              % Kg
ts = 0.001;               % Seconds
virtualSpringConst = 100;
timelim = 10000

% Build the nodes and the canvas
nodes = buildNodes(row, col);
plotwindow = createPlot(nodes);
plotwindow = drawNodes(S, plotwindow, nodes, 0);

% Main loop
for i = 0 : timelim

    %Update the position of the nodes
    nodes = updateNode(nodes, mass, stiffness, damping, ts);
    
    %Do not update every timestep (for efficiency)
    if mod(i, 10) == 0
        plotwindow = drawNodes(S, plotwindow, nodes, ts);
       
        
    end
end


%% Create plot window

function plot = createPlot(nodes)
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
ylim([canvas_min(2)-range(2)*nodes.row canvas_max(2)])
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
set(S.mText,'String', timestep);

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
        node(r,c).acc = [0 0];
        node(r,c).vel = [0 0];
        node(r,c).force_ext = [0 0];
        
        if (r == 1)
            node(r,c).isFixed = 1;
        else
            node(r,c).isFixed = 0;
        end
    end
end

nodes.node = node;
end

%% Update the position of each node

function nodes = updateNode(nodes, mass, stiffness, damping, ts)

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

    % Position, velocity, and accelleration update
    for r = 1 : row        
        for c = 1: col
            if  node(r,c).isFixed ~= 1            
                node(r,c).acc = node(r,c).force ./ mass;
                node(r,c).vel = node(r,c).vel + node(r,c).acc .* ts;
                node(r,c).pos = node(r,c).pos + node(r,c).vel .* ts;           
            end               
        end
    end
    
    nodes.node = node;
end

%% Euler function

function xt1 = EulerUpdate(xt, ts)

    

end



%% Verlet function
