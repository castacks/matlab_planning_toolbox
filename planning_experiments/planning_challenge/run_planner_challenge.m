%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

clc;
clear;
close all;

%% Challenge Folder
folder = 'planning_challenge_train';
num_env = 10;

%% Challenge rules (please dont modify this)
failure_cost = 10;
bbox = [-1 -1; 1 1];
start = [0 0];
goal = [1 0];
visualize = 1; % Please turn off visualization when reporting the final result)

if (visualize)
    planning_times = [2 2 2 2 2 20 20 20 20 20];
else
    planning_times = 0.5*[2 2 2 2 2 20 20 20 20 20];
end

%% Create planner ensemble
ensemble = {'weighted_astar_config', 'rrt_config'}; % Create an ensemble of MAXIMUM TWO PLANNERS 

%% Run challenge
total_cost = 0;
for env_idx = 1:num_env
    fprintf('\n ****** Env: %d ****** \n\n', env_idx);
    load(strcat('../../saved_environments/',folder,'/env',sprintf('%02d',env_idx),'.mat'));
    
    ensemble_cost = failure_cost;
    for planner_config_idx = 1:length(ensemble)
        planner_config = ensemble{planner_config_idx};
        planner_config_fn = str2func(planner_config);
        
        % Load planner function
        planner = planner_config_fn (start, goal, map, cost_map, bbox, planning_times(env_idx), visualize);
        
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
        fprintf('Result for planner: %s \n', planner_config);
        found_path = ~isempty(final_path);
        fprintf('Found path: %d \n', found_path);
        if (found_path)
            in_collision = cost_fn_map_coll_dense(final_path, map);
            fprintf('Is solution in collision: %d \n', in_collision);
            if (~in_collision)
                fprintf('Length of solution: %f\n', traj_length(final_path));
                ensemble_cost = min(ensemble_cost, traj_length(final_path));
            end
        end
    end
    total_cost = total_cost + ensemble_cost;
    fprintf('Cumulative cost: %f \n', total_cost);
end

fprintf('Total score to report: %f \n', total_cost);