function sample_set = sampling_random_uniform_valid(cost_to_come, collision_fn, num, bbox)
%IMPLICIT_GRAPH_TEMPLATE Summary of this function goes here
%   Detailed explanation goes here

count = 1;
sample_set = vertex.empty();
while count <= num
    sample_state = bbox(1,:) + (bbox(2,:) - bbox(1,:)).*rand(1, size(bbox,2));
    sample = vertex(0, sample_state, 0, inf, inf, [], [], []);
    if(collision_fn(sample.state))
        continue;
    end
    sample_set(1, count) = sample;
    count = count + 1;
end

end

