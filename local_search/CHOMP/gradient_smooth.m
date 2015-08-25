%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function grad = gradient_smooth( xi, A, b )
%GRADIENT_SMOOTH Summary of this function goes here
%   Detailed explanation goes here

grad = size(xi,1)*(A*xi+b);
end

