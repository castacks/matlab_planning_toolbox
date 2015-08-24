%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

old_folder = cd('environment_generation');
run init_setup;
cd(old_folder);

old_folder = cd('cost_functions');
run init_setup;
cd(old_folder);

old_folder = cd('local_search');
run init_setup;
cd(old_folder);

old_folder = cd('global_search');
run init_setup;
cd(old_folder);

clc;
clear;
close all;