%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function planner = weight_astar_8conn_config( start, goal, map, cost_map, bbox, plan_time, visualize )
%WEIGHT_ASTAR_8CONN_CONFIG Summary of this function goes here
%   Detailed explanation goes here

options = global_search_options(start, goal, bbox); % get default options

%% Setup cost function
options.c = @(v1, v2) cost_fn_map_coll_traj(v1.state, v2.state, map, inf);

%% Setup heuristic
heuristic_inflation = 10.0;
options.h_hat = @(v) heuristic_inflation*pdist2(cell2mat({v.state}'), goal);

%% Setup Implicit Graph
resolution = 40;
options.sampler = @(g_t) sampling_lattice2D_static(g_t, resolution, start, goal, bbox);
options.succ_func = @(query, V, S, total_size) succ_func_lattice2D_8conn_static( query, V, S, total_size, resolution, bbox);


%% Set stopping conditions
options.max_batches = 1;
options.max_iter = inf;
options.max_time = plan_time;
options.visualize = visualize;

%% Create planner function handle
planner = @() batch_sample_planner( start, goal, options );

end

