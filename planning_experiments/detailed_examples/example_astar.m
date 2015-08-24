%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

clc;
clear;
close all;

load ../../saved_environments/baffle_env.mat
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
resolution = 40;
options.sampler = @(g_t) sampling_lattice2D_static(g_t, resolution, start, goal, bbox);
options.succ_func = @(query, V, S, total_size) succ_func_lattice2D_8conn_static( query, V, S, total_size, resolution, bbox);


%% Set stopping conditions
options.max_batches = 1;
options.max_iter = inf;
options.max_time = 60.0;

%Visualization and Logging
options.visualize = 1;

%% Setup visualizations
figure;
axis(reshape(bbox, 1, []));
hold on;
visualize_map(map);

%% Call BIT*
[final_cost, final_path, log_data] = batch_sample_planner( start, goal, options );
