%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function plot_goal_vs_batch(log_data, upper_bound )
%PLOT_GOAL_VS_BATCH Summary of this function goes here
%   Detailed explanation goes here
if (nargin <= 1)
    upper_bound = inf;
end
num_batch = log_data.batch(end);
batch_cost = [];
for i = 1:num_batch
    if (min(log_data.goal_cost(log_data.batch == i)) < upper_bound)
        batch_cost = [batch_cost; i min(log_data.goal_cost(log_data.batch == i))];
    end
end


plot(batch_cost(:,1), batch_cost(:,2))

end

