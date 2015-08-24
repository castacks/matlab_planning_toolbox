%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function cost = cost_fn_shapes_traj(  p_start, p_end, shapes_array, infinity )
%COST_FN_SHAPES_TRAJ Summary of this function goes here
%   Detailed explanation goes here

if (nargin == 3)
    infinity = inf;
end

if (shapes_collision_check( p_start, p_end, shapes_array ))
    cost = infinity;
else
    cost = norm(p_end - p_start);
end

end

