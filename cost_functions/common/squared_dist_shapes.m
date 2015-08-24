%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function [c] = squared_dist_shapes( pt, shapes_array, epsilon )
%SQUARED_DIST_SHAPES Summary of this function goes here
%   Detailed explanation goes here

[~, d, ~] = shapes_point_check( pt, shapes_array );
if (d < 0)
    c = -d + 0.5*epsilon;
elseif (d < epsilon)
    c = (1/(2*epsilon))*(d - epsilon)^2;
else
    c = 0;
end

end

