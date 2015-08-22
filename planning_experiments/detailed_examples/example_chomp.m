clc;
clear;
close all;

load ../../saved_environments/baffle_env.mat
bbox = [-1 -1; 1 1];
start = [0 0];
goal = [1 0];

[ cost_map_x, cost_map_y] = get_cost_map_derivatives( cost_map );

%% Create Initial Guess
n = 100; %How many waypoints
xi = [linspace(start(1),goal(1),n)' linspace(start(2),goal(2),n)'];

%% Create Cost Function
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
options.eta = 2000;
options.max_iter = 100;
options.min_iter = 10;
options.min_cost_improv_frac = 1e-5;
options.M = A;
options.decrease_wt = 1;
options.progress = 0;

%% Do CHOMP
[ cost_traversal, time_taken, cost_history, traj_history] = covariant_gradient_descent( xi, c_final, grad_final, options );

%% Setup visualizations
figure;
axis(reshape(bbox, 1, []));
hold on;
visualize_map(map);
plot_traj_history(traj_history);