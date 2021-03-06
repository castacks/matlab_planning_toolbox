%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

clc;
clear;
close all;

%% Load environment, start goal and bounding bx
load ../../saved_environments/env_baffle.mat
bbox = [-1 -1; 1 1];
start = [0 0];
goal = [1 0];

%% Create cost function derivatives used by CHOMP
[ cost_map_x, cost_map_y] = get_cost_map_derivatives( cost_map );

%% Create Initial Guess
n = 100; %How many waypoints
xi = [linspace(start(1),goal(1),n)' linspace(start(2),goal(2),n)'];

%% Create surrogate cost function used by CHOMP
w_obs = 100;
lambda = 1;

[ A, b, c ] = smooth_matrices(start, goal, n-2);
f_smooth = @(xi) cost_smooth( xi, A, b, c);
grad_smooth = @(xi) fsmooth(xi, A, b);  

c_scalar_obs_fn = @(xi) cost_obs( xi, cost_map, start );
grad_fobs = @(xi) gradient_obs( xi, cost_map, cost_map_x, cost_map_y, start );

c_final = @(xi, xi_der) lambda*f_smooth(xi) + w_obs*c_scalar_obs_fn(xi);
grad_final = @(xi, xi_der) lambda*grad_smooth(xi) + w_obs*grad_fobs(xi);

%% Set optimization options
options.eta = 4000;
options.min_cost_improv_frac = 1e-5;
options.M = A;
options.decrease_wt = 1;
options.progress = 0;

%% Set stopping conditions
options.max_iter = 100;
options.min_iter = 10;
options.min_cost_improv_frac = 1e-5;
options.max_time = 10.0;

%% Visualize
options.visualize = 1;

%% Setup visualizations
figure;
axis(reshape(bbox, 1, []));
hold on;
visualize_map(map);

%% Do CHOMP
[final_path] = covariant_gradient_descent( xi, c_final, grad_final, options );

%% Check path
found_path = ~isempty(final_path);
fprintf('Found path: %d \n', found_path);
if (found_path)
    in_collision = cost_fn_map_coll_dense(final_path, map);
    fprintf('Is solution in collision: %d \n', in_collision);
    if (~in_collision)
        fprintf('Length of solution: %f\n', traj_length(final_path));
    end
end
