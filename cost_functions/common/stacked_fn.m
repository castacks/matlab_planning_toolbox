%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function val = stacked_fn( xi, fn )
%STACKED_FN Summary of this function goes here
%   Detailed explanation goes here

val = [];
for t = 1:size(xi,1)
    val = [val; fn(xi(t,:))];
end

end

