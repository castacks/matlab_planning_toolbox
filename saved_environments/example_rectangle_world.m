%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

clc;
clear;
close all;

% %% Create analytic world
bbox = [-1 1 -1 1];
figure;
axis(bbox);
grid on;
count = 1;
while(1)
    title('Drag rect');
    final_rect = getrect(gca);
    rectangle('Position',final_rect,'FaceColor','r');
    shapes_array(count) = get_rectangle_shape(final_rect(1), final_rect(2), final_rect(3), final_rect(4));
    count = count + 1;
    title('Left click to continue, right click to stop');
    [~,~,button] = ginput(1);
    if (button == 3)
        break;
    end
end

resolution = 0.001;
map = convert_shape_array_to_map(shapes_array, bbox, resolution);

epsilon = 0.05;
cost_map = create_obstacle_cost_map(map, epsilon);
