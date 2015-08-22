function Vsucc = succ_func_rdisk( query, V, S, total_size, eta, start, goal, bbox)
%SUCC_FUNC_RDISK Summary of this function goes here
%   Detailed explanation goes here
    vol = prod(bbox(2,:) - bbox(1,:));
    dim = length(start);
    r = 2*eta*((1 + 1/dim)^(1/dim))*((  vol / spheresegmentvolume([],dim))^(1/dim))*(log(total_size + 1)/ (1 + total_size))^(1/dim);
    
    V_list = S.get_element(V.get_idx());
    if (~isempty(V_list))
        dist = pdist2(cell2mat({V_list.state}'), query.state);
        Vsucc = V_list(dist - r <= 0); % Line 2
        if (isempty(V_list))
            [~, min_idx] = min(dist);
            Vsucc = V_list(min_idx);
        end
    else
        Vsucc = [];
    end
end

