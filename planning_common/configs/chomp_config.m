function planner = chomp_config( start, goal, map, cost_map, bbox, plan_time, visualize )
%CHOMP_CONFIG Summary of this function goes here
%   Detailed explanation goes here

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
options.eta = 4000;
options.max_iter = 100;
options.min_iter = 10;
options.min_cost_improv_frac = 1e-5;
options.M = A;
options.decrease_wt = 1;
options.progress = 0;

options.max_time = plan_time;
options.visualize = visualize;
%% Do CHOMP
planner = @() covariant_gradient_descent( xi, c_final, grad_final, options );
end

