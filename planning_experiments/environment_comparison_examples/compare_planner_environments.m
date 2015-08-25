%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

clc;
clear;
close all;

%% Make a list of environment names
env_names = {'env01', 'env02', 'env03'};

%% Make a list of planner configurations
planner_config_names = {'chomp_config', 'rrtstar_config', 'weighted_astar_config'};

%% Set experiment configurations
visualize = 1; %do we want to visualize?
plan_time = 30.0; %how much planning time (sec) do we want to give? (if visualizing, give 30 to 60 s)
bbox = [-1 -1; 1 1];
start = [0 0];
goal = [1 0];


%% Run experiments
for env_idx = 1:length(env_names)
    env = env_names{env_idx};
    load(strcat('../../saved_environments/',env,'.mat'));
    
    for planner_config_idx = 1:length(planner_config_names)
        planner_config = planner_config_names{planner_config_idx};
        planner_config_fn = str2func(planner_config);
        
        % Load planner function
        planner = planner_config_fn (start, goal, map, cost_map, bbox, plan_time, visualize);
        
        % If visualization, then see the map
        if (visualize)
            close all;
            figure;
            axis(reshape(bbox, 1, []));
            hold on;
            visualize_map(map);
        end
        
        % Execute planner on environment
        [final_path] = planner();
        
        % Check path
        fprintf('Result for env: %s planner: %s \n', env, planner_config);
        found_path = ~isempty(final_path);
        fprintf('Found path: %d \n', found_path);
        if (found_path)
            in_collision = cost_fn_map_coll_dense(final_path, map);
            fprintf('Is solution in collision: %d \n', in_collision);
            if (~in_collision)
                fprintf('Length of solution: %f\n', traj_length(final_path));
            end
        end
    end
end