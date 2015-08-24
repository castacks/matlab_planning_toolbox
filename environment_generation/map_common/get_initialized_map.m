%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function map = get_initialized_map( bbox, resolution )
%GET_INITIALIZED_MAP Summary of this function goes here
%   Detailed explanation goes here

map = get_blank_map();
map.resolution = resolution;
map.origin = [bbox(1) bbox(3)];
[row, col] = world_to_grid(bbox(2), bbox(4), map);
map.table = ones(row, col);

end

