function options = global_search_options(start, goal, bbox)
%BITSTAR_OPTIONS Summary of this function goes here
%   Detailed explanation goes here

%Stopping Parameters
options.max_batches = inf;
options.max_iter = inf;
options.max_time = inf;

%Visualization and Logging
options.visualize = 1;
options.visualize_delay = 0.01;
options.should_log = 1;

%Functions
options.g_hat = @(v) pdist2(cell2mat({v.state}'), start);
options.h_hat = @(v) pdist2(cell2mat({v.state}'), goal);
options.c_hat = @(v1, v2) norm(v1.state - v2.state);
options.c = @(v1, v2) norm(v1.state - v2.state);

%Visualizations
options.sampler = @(g_t) sampling_random_uniform(g_t, 1, bbox);
options.succ_func = @(query, V, S, total_size) succ_func_rdisk( query, V, S, total_size, 1, start, goal, bbox);

end

