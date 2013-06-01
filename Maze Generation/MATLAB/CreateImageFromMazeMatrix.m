%--------------------------------------------------------------------------
%  CreateImageFromMazeMatrix.m
%  Blogdemos/Maze Generation
%
%  Created by Egor Chiglintsev on June 01 2013.
%  Copyright (c) 2013 Egor Chiglintsev. All rights reserved.
%--------------------------------------------------------------------------
%
% Returns a monochrome image matrix of a maze represented by an adjacency matrix.
%
% The resulting image may be written to a .png file using imwrite or displayed
% in MATLAB using imshow functions.
%
% The maze is defined as a set of 'rooms' distributed on a grid with each
% room possibly connected to 4 other rooms in up, down, left or right
% directions. Each room of the maze is represented by a graph vertex with
% edges connecting this vertex to vertices representing adjacent rooms.
%
% Maze graph is supposed to be non-oriented, so the adjacency matrix will
% be a symmetric one. Weights of the graph edges are irrelevant to this
% function, so we mark any edge with nonzero weight with white color (1)
% and any nonexistent (zero-weight) edges with black color (0).
%
% Each room of the maze is represented by a graph vertex, so there will be
% width * height different vertices and the adjacency matrix should
% therefore be of (width * height)^2 size. Sparse representation is
% recommended for larger mazes.

function [image] = CreateImageFromMazeMatrix(matrix, width, height)
% Each room of the maze is represented by a 3x3 grid of pixels. The central
% pixel is the room itself and 4 pixels in up, down, left and right
% directions represent passages between the rooms. So white pixels are
% passable and black pixels represent walls of the maze.
imageWidth  = width  * 3;
imageHeight = height * 3;

% Resulting image is a matrix of the corresponding size. For convenience we
% use the first dimension as the X axis and the second dimension as the Y
% axis.
image = zeros(imageWidth, imageHeight);

% We'll be using zero-based indices for the computations similar to the
% arrays in C, C++ or similar languages. Note that matrices in MATLAB are
% indexed from 1, so we'll have to add +1 when actually accessing them.
for mx = 0:width-1      % iterate through X axis of the maze
    for my = 0:height-1 % iterate through Y axis of the maze
        
        % Index of the current 'room' in the graph adjacecy matrix.
        i = my * width + mx;
        
        % (x,y) is the center point of a 3x3 pixels room representation on
        % the resulting image. Note that this index is zero-based.
        x = mx * 3 + 1;
        y = my * 3 + 1;
        
        % In some configurations a room may not have any passages leading
        % to it (i.e. an isolated room). We won't draw these rooms at all
        % in the resulting image. This variable will act as a flag which
        % determines whether or not any passages were added to this
        % particular room.
        passagesAdded = 0;
        
        
        % Draw the passage to the right if present
        if mx < width-1
            
            % Get an index of the right adjacent vertex
            j = my * width + (mx + 1);
            
            % Check the weight of the corresponding edge
            % (note that we are adding +1 here in both dimensions since we
            % use zero-based indices)
            if matrix(i+1,j+1) > 0
                
                % We actually have to paint 2 pixels of the image to mark
                % the passage since each room is represented by a 3x3
                % pixels grid and between two centers of the adjacent rooms
                % there are exactly 2 pixels.
                image(x+1+1,y+1) = 1;
                image(x+1+2,y+1) = 1;
                
                % Mark that we've added a passage
                passagesAdded = 1;
            end
        end
        
        
        % Draw the passage in down direction if present
        if my < height-1
            j = (my + 1) * width + mx;
            
            if matrix(i+1,j+1) > 0
                image(x+1, y+1+1) = 1;
                image(x+1, y+1+2) = 1;
                
                passagesAdded = 1;
            end
        end
        
        
        % Draw the passage to the left if present
        if mx > 0
            j = my * width + (mx-1);
            
            if matrix(i+1,j+1) > 0
                
                image(x+1-1, y+1) = 1;
                image(x+1-2, y+1) = 1;
                
                passagesAdded = 1;
            end
        end
        
        
        % Draw the passage to the up direction if present
        if my > 0
            j = (my-1) * width + mx;
            
            if matrix(i+1,j+1) > 0
                
                image(x+1, y+1-1) = 1;
                image(x+1, y+1-2) = 1;
                
                passagesAdded = 1;
            end
        end
        
        
        % And last but not least we mark the center of the room if any
        % passages were actually added.
        if passagesAdded > 0
            image(x+1,y+1) = 1;
        end
    end
end


% imwrite and imshow functions expect Y axis to be represented as the first
% dimension of the image matrix and X axis as the second dimension. We've
% done the opposite so we have to transpose the image matrix here.
image = image';

end

