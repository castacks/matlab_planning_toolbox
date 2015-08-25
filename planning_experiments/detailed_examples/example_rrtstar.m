%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%


clc;
clear;
close all;

load ../../saved_environments/env_hard.mat
bbox = [-1 -1; 1 1];
start = [0 0];
goal = [1 0];

rng(200);

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
options.max_batches = inf;
options.max_iter = 1e3;
options.max_time = 30.0;

%Visualization and Logging
options.visualize = 1;

%% Setup visualizations
figure;
axis(reshape(bbox, 1, []));
hold on;
visualize_map(map);

%% Call BIT*
[final_cost, final_path, log_data] = single_sample_planner( start, goal, options );


