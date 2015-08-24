%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function l = traj_length( xi )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
dxi = diff(xi,1,1);
l = sum(sqrt(sum(dxi.^2,2)));

end

