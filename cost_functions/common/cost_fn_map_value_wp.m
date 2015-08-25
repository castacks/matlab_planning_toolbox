%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function cost = cost_fn_map_value_wp( wp, map )
%COST_FN_MAP_VALUE Summary of this function goes here
%   Detailed explanation goes here

idx = world_wp_to_grid( wp, map );
cost = map.table(sub2ind(size(map.table), idx(:,1), idx(:,2)));

end

