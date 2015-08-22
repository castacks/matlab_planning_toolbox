function path = global_search_path( S, goal_id )
%BITSTAR_PATH Summary of this function goes here
%   Detailed explanation goes here

path = [];
iter_id = goal_id;
while (1)
    x = S.get_element(iter_id);
    path = [x.state x.cost_from_start; path];
    iter_id = x.parent_idx;
    if (iter_id == 0)
        path = [];
        return;
    end
    if (x.idx == x.parent_idx)
        break
    end
end

end

