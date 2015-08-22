function sample_set = manual_sampler()
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
global infty
sample_set = vertex.empty();
count = 1;
while(1)
    [x,y,button] = ginput(1);
    if (button == 3)
        break;
    end
    sample_state = [x y];
    sample = vertex(0, sample_state, 0, infty, infty, [], [], []);
    sample_set(1, count) = sample;
    count = count + 1;
end
    

end

