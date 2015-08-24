%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function plot_goal_vs_time(log_data, upper_bound )
%PLOT_GOAL_VS_BATCH Summary of this function goes here
%   Detailed explanation goes here
if (nargin <= 1)
    upper_bound = inf;
end

semilogx(log_data.time(log_data.goal_cost < upper_bound), log_data.goal_cost(log_data.goal_cost < upper_bound));

end

