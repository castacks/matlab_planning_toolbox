%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function visualize_map( map )
%VISUALIZE_MAP Summary of this function goes here
%   Detailed explanation goes here

colormap(gray)
imagesc([map.origin(1) map.origin(1)+map.resolution*size(map.table,1)], [map.origin(2) map.origin(2)+map.resolution*size(map.table,2)], map.table');
axis xy;

end

