%% Cost map for ICRA

clc;
clear;
close all;

load map_bitstar2.mat;

figure;
visualize_map(map);

cost_map = create_obstacle_cost_map(map, 0.05);
figure;
visualize_cost_map(cost_map);
