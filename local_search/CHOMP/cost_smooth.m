%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function [ cost_traj ] = cost_smooth( xi, A, b, c)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

cost_traj = (size(xi,1)+1)*trace(0.5*xi'*A*xi + xi'*b + c);

end

