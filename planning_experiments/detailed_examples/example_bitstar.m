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
samples_per_batch = 100;
options.sampler = @(g_t) sampling_random_uniform_rejection(g_t, @(v) options.g_hat(v) + options.h_hat(v), ...
                                                          @(s) cost_fn_map_value( s, map ) < 0.5, samples_per_batch, bbox);
radius_multiplier = 1;
options.succ_func = @(query, V, S, total_size) succ_func_rdisk( query, V, S, total_size, radius_multiplier, start, goal, bbox);

%% Set stopping conditions
options.max_batches = 10;
options.max_iter = inf;
options.max_time = 30.0;

%Visualization and Logging
options.visualize = 1;

%% Setup visualizations
figure;
axis(reshape(bbox, 1, []));
hold on;
visualize_map(map);

%% Call BIT*
[final_cost, final_path, log_data] = batch_sample_planner( start, goal, options );


