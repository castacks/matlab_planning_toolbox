%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function planner = astar_random_config( start, goal, map, cost_map, bbox, plan_time, visualize )
%ASTAR_RANDOM_CONFIG Summary of this function goes here
%   Detailed explanation goes here

rng(200);
options = global_search_options(start, goal, bbox); % get default options

%% Setup cost function
options.c = @(v1, v2) cost_fn_map_coll_traj(v1.state, v2.state, map, inf);

%% Setup heuristic
heuristic_inflation = 3;
options.h_hat = @(v) heuristic_inflation*pdist2(cell2mat({v.state}'), goal);

%% Setup Implicit Graph
samples_per_batch = 1000;
options.sampler = @(g_t) sampling_random_uniform_rejection(g_t, @(v) options.g_hat(v) + options.h_hat(v), ...
                                                          @(s) cost_fn_map_value( s, map ) < 0.5, samples_per_batch, bbox);
radius_multiplier = 1;
options.succ_func = @(query, V, S, total_size) succ_func_rdisk( query, V, S, total_size, radius_multiplier, start, goal, bbox);

%% Set stopping conditions
options.max_batches = 1;
options.max_iter = inf;
options.max_time = plan_time;
options.visualize = visualize;

planner = @() batch_sample_planner( start, goal, options );


end

