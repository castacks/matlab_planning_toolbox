function planner = informed_rrtstar_config( start, goal, map, cost_map, bbox, plan_time, visualize )
%INFORMED_RRTSTAR_CONFIG Summary of this function goes here
%   Detailed explanation goes here

rng(200);
options = global_search_options(start, goal, bbox); % get default options

%% Setup cost function
options.c = @(v1, v2) cost_fn_map_coll_traj(v1.state, v2.state, map, inf);

%% Setup heuristic
options.g_hat = @(v) pdist2(cell2mat({v.state}'), start);
options.h_hat = @(v) pdist2(cell2mat({v.state}'), goal);
options.c_hat = @(v1, v2) norm(v1.state - v2.state);

%% Setup Implicit Graph
options.sampler = @(g_t) sampling_random_uniform_rejection(g_t, @(v) options.g_hat(v) + options.h_hat(v), ...
                                                          @(s) cost_fn_map_value( s, map ) < 0.5, 1, bbox);
radius_multiplier = 3;
options.succ_func = @(query, V, S, total_size) succ_func_rdisk( query, V, S, total_size, radius_multiplier, start, goal, bbox);


%% Set stopping conditions
options.max_batches = inf;
options.max_iter = inf;
options.max_time = plan_time;
options.visualize = visualize;

%% Create planner function handle
planner = @() single_sample_planner( start, goal, options );


end

