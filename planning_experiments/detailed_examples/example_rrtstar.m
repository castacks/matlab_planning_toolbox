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

rng(100); % Seed of random number generator

%% Get global search options
options = global_search_options(start, goal, bbox); % get default options

%% Setup cost function
options.c = @(v1, v2) cost_fn_map_coll_traj(v1.state, v2.state, map, inf);

%% Setup heuristic
options.g_hat = @(v) pdist2(cell2mat({v.state}'), start);
options.h_hat = @(v) pdist2(cell2mat({v.state}'), goal);
options.c_hat = @(v1, v2) norm(v1.state - v2.state);

%% Setup Implicit Graph
options.sampler = @(g_t) sampling_random_uniform_valid(g_t, @(s) cost_fn_map_value( s, map ) < 0.5, 1, bbox);
radius_multiplier = 1;
options.succ_func = @(query, V, S, total_size) succ_func_rdisk( query, V, S, total_size, radius_multiplier, start, goal, bbox);

%% Set stopping conditions
options.max_batches = 1;
options.max_iter = inf;
options.max_time = 30.0;

%% Do you want to visualize planner progress (it will take longer)
options.visualize = 1;

%% Setup visualizations
figure;
axis(reshape(bbox, 1, []));
hold on;
visualize_map(map);

%% Call Planner
[final_path] = single_sample_planner( start, goal, options );


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
