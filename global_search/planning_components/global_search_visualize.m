%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function handle_set = global_search_visualize(handle_set, S, V, Xsamp, goal_id, edge_being_cons)
%BITSTAR_VISUALIZE Summary of this function goes here
%   Detailed explanation goes here

if (~isempty(handle_set))
    delete(handle_set);
end

handle_set = [];
if (~isempty(Xsamp.get_idx()))
    samples = cell2mat({S.get_element(Xsamp.get_idx()).state}');
    handle_set = [handle_set scatter(samples(:,1), samples(:,2), 'r')];
end

for v = S.get_element(V.get_idx())
    v_parent = S.get_element(v.parent_idx);
    handle_set = [handle_set plot([v.state(1) v_parent.state(1)], [v.state(2) v_parent.state(2)], 'Color','blue')];
end



path = global_search_path( S, goal_id );
if (~isempty(path))
    handle_set = [handle_set plot(path(:,1), path(:,2),'Color','green','LineWidth',2)];
end

if (~isempty(edge_being_cons))
    handle_set = [handle_set plot(edge_being_cons(:,1), edge_being_cons(:,2), 'y--')];
end

title(strcat('Cost to goal:  ', num2str(S.get_element(goal_id).cost_from_start)));

end

