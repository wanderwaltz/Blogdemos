%--------------------------------------------------------------------------
%  GenerateHorseMaze.m
%  Blogdemos/Maze Generation
%
%  Created by Egor Chiglintsev on June 01 2013.
%  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
%--------------------------------------------------------------------------


% Reset the global state and clear the MATLAB console.
clear all;
clc;

% See the GenerateSimpleMaze.m script for general comments on the maze
% generation. In this script we do something a bit different and create a
% maze with nonrectangular shape using a monochrome image as the template.

% Load the image of the horse
horse = imread('Horse.png');

% Make sure horse is a 2-dimensional matrix by getting the average of the
% RGB values.
horse = sum(horse,3)/3;

% We use first dimension of the matrix as the X axis and second as the Y
% axis, but imread returns the matrix where the dimensions are transposed,
% so we transpose the matrix here.
horse = horse';

% Each pixel of the horse image will correspond to a single room of the
% maze, so we set the size of the maze equal to the size of the image.
width  = size(horse,1);
height = size(horse,2);

% Each room in the maze is represented by a graph vertex, so overall number
% of vertices will be width * height.
vertices = width * height;

% Set up a sparse adjacency matrix for the graph. Initially all the values
% in the matrix will be zero (so no passage between the corresponding rooms
% in the maze), and we'll have to set a nonzero weight for the edges of the
% graph which represent valid passages between the maze rooms.
adjacency = sparse(vertices, vertices, vertices * 4 * 2);

% We iterate the maze rooms using zero-based indices instead of starting
% them from 1 as MATLAB expects us, so we'll have to add a +1 when actually
% indexing the adjacency matrix.
for mx = 0:width-1
    for my = 0:height-1
        
        % We ignore the room if the corresponding pixel of the horse image
        % is black (0). The resulting maze matrix will have a set of rooms
        % not connected to any other rooms. The CreateImageFromMazeMatrix
        % function won't draw these rooms in the resulting image and we'll
        % have a horse-shaped maze in the end.
        if horse(mx+1,my+1) > 0
            % Zero-based index of (mx, my) room of the maze in the adjacency
            % matrix
            i = my * width + mx;

            % Add an edge to the right adjacent room 
            if mx < width-1
                j = my * width + (mx+1);
                adjacency(i+1,j+1) = rand;
            end

            % Add an edge to the bottom adjacent room
            if my < height-1
                j = (my + 1) * width + mx;
                adjacency(i+1,j+1) = rand;
            end

            % Add an edge to the left adjacent room 
            if mx > 0
                j = my * width + (mx-1);
                adjacency(i+1,j+1) = rand;
            end

            % Add an edge to the bottom adjacent room
            if my > 0
                j = (my-1) * width + mx;
                adjacency(i+1,j+1) = rand;
            end
        end
    end
end

% Make the adjacency matrix symmetric
adjacency = adjacency + adjacency';

% Create a biograph object representing our graph. We have to do that since
% minspantree function expects a biograph.
graph = biograph(adjacency);

% Compute the minimal spanning tree of the graph. Since we've set the edge
% weights to random values, our spanning tree will be different each time
% we run this script.
%
% Result of this call is an adjacency matrix of the minimal spanning tree.
spanTree = minspantree(graph);

% Make the spanning tree matrix symmetric.
spanTree = spanTree + spanTree';

% Create image representation of the graph
image = CreateImageFromMazeMatrix(spanTree, width, height);

imshow(image);
imwrite(image,'HorseMaze.png','png');