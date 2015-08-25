%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function Vsucc = succ_func_lattice2D_static( query, V, S, total_size, res, bbox)
%SUCC_FUNC_RDISK Summary of this function goes here
%   Detailed explanation goes here

r = 1.5*(bbox(2,1) - bbox(1,1))/res; %hack!

V_list = S.get_element(V.get_idx());
if (~isempty(V_list))
    Vsucc = V_list(pdist2(cell2mat({V_list.state}'), query.state) - r <= 0); 
else
    Vsucc = [];
end

end

