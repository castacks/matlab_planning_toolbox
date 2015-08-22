function cost = cost_function_traj_wp( traj, map)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
% traj includes both waypoints

c_traj = cost_fn_map_value_wp( traj(1:(end-1),:), map );
cost = sum(sqrt(sum((diff(traj)).^2,2)) .* c_traj);
end

