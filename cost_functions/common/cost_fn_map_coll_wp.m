%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function cost = cost_fn_map_coll_wp( wp, map, infinity )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if (nargin == 3)
    infinity = inf;
end
idx = world_wp_to_grid( wp, map );
c = map.table(sub2ind(size(map.table), idx(:,1), idx(:,2)));


if (any(~c))
    cost = infinity;
else
    cost = 0;
end


end

