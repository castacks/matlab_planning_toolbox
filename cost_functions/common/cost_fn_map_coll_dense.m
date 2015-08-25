%%
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function in_collision = cost_fn_map_coll_dense( traj, map)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


in_collision = 0;
for k = 2:size(traj,1)
    p_start = traj(k-1,:);
    p_end = traj(k,:);
    idx = world_traj_to_grid( p_start, p_end, map );
    c = map.table(sub2ind(size(map.table), idx(:,1), idx(:,2)));


    if (any(~c))
        in_collision = 1;
    end
end

end


