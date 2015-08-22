function cost = cost_fn_map_coll_traj( p_start, p_end, map, infinity )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if (nargin == 3)
    infinity = inf;
end
idx = world_traj_to_grid( p_start, p_end, map );
c = map.table(sub2ind(size(map.table), idx(:,1), idx(:,2)));


if (any(~c))
    cost = infinity;
else
    cost = norm(p_end - p_start);
end


end

