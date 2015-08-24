%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function grad = grad_shapes( x,  pt_con_grad_fn )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

xi = reshape(x, [], 2);
grad_xi = stacked_fn( xi, pt_con_grad_fn );
grad = [diag(grad_xi(:,1));diag(grad_xi(:,2))];
end

