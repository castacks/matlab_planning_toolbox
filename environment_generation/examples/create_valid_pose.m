%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

clc
clear 
close all

load final_city.mat
bbox = [-2000 2000 -2000 2000 0 300 -Inf Inf];
figure;
axis(bbox);
grid on;
draw_cuboid_set( cuboid_set );
view(0, 90);

valid_pose = [];
while (1)
    [x,y,button] = ginput(2);
    if (button == 3)
        break;
    end
    heading = atan2(y(2)- y(1), x(2)-x(1));
    valid_pose = [valid_pose; x(1) y(1) heading];
end