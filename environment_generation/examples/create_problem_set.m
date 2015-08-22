clc
clear
close all

load valid_pose.mat
min_dist = 1800;
start_goal_set = [];
for i = 1:size(valid_pose,1)
    for j = 1:size(valid_pose,1)
        if (norm(valid_pose(i,1:2) - valid_pose(j,1:2)) > min_dist)
            start_goal_set = [start_goal_set; valid_pose(i,:) valid_pose(j,1:2) wrapToPi(pi+valid_pose(j,3))];
        end
    end
end