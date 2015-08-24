%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

% clc;
% clear;
% close all;

%load ../saved_maps/env3.mat
%% Create analytic world
bbox = [-1 1 -1 1];

for count = 1:length(shapes_array)
    rectangle_array(count).low = shapes_array(count).data(1:2);
    rectangle_array(count).high = shapes_array(count).data(1:2) + shapes_array(count).data(3:4);
end

resolution = 0.001;

map = rectangle_maps( bbox, rectangle_array, resolution);

%% Admire work
figure;
visualize_map(map);