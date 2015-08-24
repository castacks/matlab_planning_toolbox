%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function [opt_traj, opt_cost]  = select_mincost_traj( xi, cov_desc_fn )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

[ ~, ~, cost_history, traj_history] = cov_desc_fn(xi);
[opt_cost, min_idx] = min(cost_history);
opt_traj = traj_history(min_idx).x';
cost_history
end

