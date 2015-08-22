clc;
clear;
close all;
% 
% % %% Create analytic world
% load ../saved_shape_arrays/bitstar_test.mat
% figure;
% hold on;
% visualize_shapes(shapes_array);
% grid on;
% while(1)
%     [x, y] = ginput(1);
%     scatter(x, y, 5, [0 0 1]);
%     [collision, d, grad] = shapes_point_check( [x y], shapes_array );
%     str = sprintf('Distance is %f , Grad is %f %f', d, grad(1), grad(2));
%     title(str);
%     pause;
%     clf;
%     hold on;
%     visualize_shapes(shapes_array);
%     grid on;
% end


centre = [0.5 0.5 0.5];
width = [0.2 0.3 0.4];
shapes_array(1) = get_hypercube_axis_aligned_shape(centre, width);
check_list = [0.3 1.1 0.5;
              0.4 0.5 0.5];

for i = 1:size(check_list,1)
    pt = check_list(i,:);
    [collision, d, grad] = shapes_point_check(pt, shapes_array);
    collision
    d
    grad
end
