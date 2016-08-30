%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

clc;
clear;
close all;

%% Load environment, start goal and bounding bx
load ../../saved_environments/env_baffle.mat
bbox = [-1 -1; 1 1];
start = [0 0];
goal = [1 0];

%% Get global search options
options = global_search_options(start, goal, bbox); % get default options

%% Setup cost function
options.c = @(v1, v2) cost_fn_map_coll_traj(v1.state, v2.state, map, inf);

%% Setup heuristic
heuristic_inflation = 10;
options.h_hat = @(v) heuristic_inflation*pdist2r(cell2mat({v.state}'), goal);

%% Setup Implicit Graph
resolution = 40;
options.sampler = @(g_t) sampling_lattice2D_static(g_t, resolution, start, goal, bbox);
options.succ_func = @(query, V, S, total_size) succ_func_lattice2D_4conn_static( query, V, S, total_size, resolution, bbox);

%% Set stopping conditions
options.max_batches = 1;
options.max_iter = inf;
options.max_time = 60.0;

%% Do you want to visualize planner progress (it will take longer)
options.visualize = 1;

%% Setup visualizations
figure;
axis(reshape(bbox, 1, []));
hold on;
visualize_map(map);

%% Call Planner
[final_path] = batch_sample_planner( start, goal, options );

%% Check path
found_path = ~isempty(final_path);
fprintf('Found path: %d \n', found_path);
if (found_path)
    in_collision = cost_fn_map_coll_dense(final_path, map);
    fprintf('Is solution in collision: %d \n', in_collision);
    if (~in_collision)
        fprintf('Length of solution: %f\n', traj_length(final_path));
    end
end