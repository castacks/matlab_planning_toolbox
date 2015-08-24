%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function shape = get_rectangle_shape(x,y,w,h)

shape = get_blank_shape();
shape.name = 'rectangle';
shape.data = [x y w h];

end

