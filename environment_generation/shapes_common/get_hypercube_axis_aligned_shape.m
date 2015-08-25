%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function shape = get_hypercube_axis_aligned_shape(lb,width)

shape = get_blank_shape();
shape.name = 'hypercube_axis_aligned';
shape.data = [lb; width];

end
