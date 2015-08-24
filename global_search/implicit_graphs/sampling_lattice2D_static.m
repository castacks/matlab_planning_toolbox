%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function sample_set = sampling_lattice2D_4conn_static(cost_to_come, res, start, goal, bbox)
%IMPLICIT_GRAPH_TEMPLATE Summary of this function goes here
%   Detailed explanation goes here

% res is number of samples per dim


count = 1;
sample_set = vertex.empty();
for i = 0:res
    for j = 0:res
        sample_state = bbox(1,:) + (bbox(2,:) - bbox(1,:)).*[i/res j/res];
        if (norm((start - sample_state)./(bbox(2,:) - bbox(1,:))) < 1/res || norm((goal - sample_state)./(bbox(2,:) - bbox(1,:))) < 1/res)
            continue;
        end
        sample = vertex(0, sample_state, 0, inf, inf, [], [], []);
        sample_set(1, count) = sample;
        count = count + 1;
    end
end


end