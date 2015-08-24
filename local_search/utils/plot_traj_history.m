%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function plot_traj_history( traj_history, plot_z )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

if (nargin <= 1)
    plot_z = 0;
end

hold on;
cc=hsv(size(traj_history,1));
for i = 1:size(traj_history,1)
    if (~plot_z)
        plot(traj_history(i).x(1,:), traj_history(i).x(2,:),'color',cc(i,:))
    else
        plot(traj_history(i).x(1,:), -traj_history(i).x(3,:),'color',cc(i,:))
    end
end
hold off;
end

