%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

%% Set up the workspace with relevant paths (and additional packages that this system needs)
addpath(genpath(strcat(pwd,'/graph_utils')));
addpath(genpath(strcat(pwd,'/implicit_graphs')));
addpath(genpath(strcat(pwd,'/planning_components')));
addpath(genpath(strcat(pwd,'/planning_methods')));
addpath(genpath(strcat(pwd,'/misc_utils')));

old_folder1 = cd('misc_utils/myqueue_1.1/');
run build_queue
cd(old_folder1);

