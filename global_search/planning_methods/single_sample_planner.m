%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function [final_path, final_cost, log_data] = single_sample_planner( start, goal, options )
%BITSTAR Summary of this function goes here
%   Detailed explanation goes here

%% Initialization

infty = 1e10;

%Functions
g_hat = options.g_hat;
h_hat = options.h_hat;
f_hat = @(v) g_hat(v) + h_hat(v);
c_hat = options.c_hat;
c = options.c;
g_t   = @(v) cell2mat({v.cost_from_start}');

visualize = options.visualize;
visualize_delay = options.visualize_delay;

should_log = options.should_log;
max_iter = options.max_iter;
max_batches = options.max_batches;
max_time = options.max_time;
sampler = options.sampler;
succ_func = options.succ_func;


function c = eq_cost(v1, v2)
    if (isempty(v1) || isempty(v2))
        c = infty;
    else
        c = g_t(v1) + c_hat(v1,v2) + h_hat(v2);
    end
end

%% Line 1
S = container_set(vertex.empty());
V = vertex_set();
E = edge_set();
E_hash = container_set(edge_element.empty());
Xsamp = vertex_set();

v_start = vertex(S.get_next_idx(), start, S.get_next_idx(), 0, 0, [], [], []);
S.add_element(v_start);
V.add_vertex(v_start.idx);

v_goal = vertex(S.get_next_idx(), goal, 0, infty, infty, [], [], []);
S.add_element(v_goal);
goal_id = v_goal.idx;

%% Line 2
Qe = general_queue();

%% Line 3 - 27 main loop
handle_set = [];
edge_being_cons = [];

timerval = tic;
log_data = [];
iter = 0;
num_collcheck = 0;
num_optimcalls = 0;

while(toc(timerval) < max_time && iter < max_iter)
    iter = iter + 1;
    
    if (should_log)
        log_data = [log_data; table(toc(timerval), iter, S.num_elements(), V.num_vertex(), num_collcheck, num_optimcalls, g_t(S.get_element(goal_id)), ...
        'VariableNames', {'time', 'iter', 'num_samples', 'num_vertices', 'num_collcheck', 'num_optimcalls', 'goal_cost'})];
    end
    
    Xsamp = vertex_set();      
    new_sample = sampler(g_t(S.get_element(goal_id)));
    new_sample.idx = S.get_next_idx();
    new_sample.parent_idx = 0;
    new_sample.cost_from_parent = infty;
    new_sample.cost_from_start = infty;
    S.add_element(new_sample);
    Xsamp.add_vertex(new_sample.idx);
    
    Qe = general_queue();
    add_incoming_edges_to_queue(new_sample.idx);
    process_edge_queue();
    
    Qe = general_queue();
    add_outgoing_edges_to_queue(new_sample.idx);
    process_edge_queue();
    
end

final_cost = S.get_element(goal_id).cost_from_start;
final_path = global_search_path( S, goal_id );
if (~isempty(final_path))
    final_path(:,3) = [];
end

function add_incoming_edges_to_queue(x_id)
    x = S.get_element(x_id);
    Vnear = succ_func(x, V, S, V.num_vertex() + 1);
    for v = Vnear
        if (g_t(v) + c_hat(v, x) + h_hat(x) < g_t(S.get_element(goal_id)))
            edge_elem = edge_element(E_hash.get_next_idx(), v.idx, x.idx);
            E_hash.add_element(edge_elem);
            Qe.push(edge_elem.idx, eq_cost(v,x));
        end
    end
end


function add_outgoing_edges_to_queue(v_id)
    v = S.get_element(v_id);
    Vnear = succ_func(v, V, S, V.num_vertex() + 1);
    Vnear = [Vnear S.get_element(goal_id)];
    % Line 7
    for w = Vnear
        if (w.idx ~= v.idx && ...
                w.parent_idx ~= v.idx && ... %safety check ;)
                ~E.has_edge(v.idx, w.idx) && ...
                g_t(v) + c_hat(v, w) + h_hat(w) < g_t(S.get_element(goal_id)) && ...
                g_t(v) + c_hat(v, w) < g_t(w))
                edge_elem = edge_element(E_hash.get_next_idx(), v.idx, w.idx);
                E_hash.add_element(edge_elem);
                Qe.push(edge_elem.idx, eq_cost(v,w));
        end
    end
end

function process_edge_queue()
    while (~Qe.is_empty())
        e_idx = Qe.pop(); %Line 13, 14
        [e1, e2] = E_hash.get_element(e_idx).get_edge();
        vm = S.get_element(e1);
        xm = S.get_element(e2);
        edge_being_cons = [vm.state; xm.state];
        
        if (visualize)
            handle_set = global_search_visualize(handle_set, S, V, Xsamp, goal_id, edge_being_cons);
            pause(visualize_delay);
        end

        if (g_t(vm) + c_hat(vm, xm) + h_hat(xm) < g_t(S.get_element(goal_id))) % Line 15
            if (g_t(vm) + c_hat(vm, xm) < g_t(xm)) %Line 25 rewarped
                % Lets do collision checking
                c_true = c(vm, xm);
                num_collcheck = num_collcheck + 1;
                if g_hat(vm) + c_true + h_hat(xm) < g_t(S.get_element(goal_id)) %Line 16
                    if g_t(vm) + c_true < g_t(xm) %Line 17
                        re_wire = 0;
                        if V.has_vertex(xm.idx) %Line 18
                            E.remove_all_parents(xm.idx);  %Line 19
                            cur_par = S.get_element(xm.parent_idx);
                            cur_par.children_set = cur_par.children_set(cur_par.children_set ~= xm.idx);
                            S.add_element(cur_par);
                            xm.parent_idx = 0;
                            xm.cost_from_parent = infty;
                            xm.cost_from_start = infty;
                            re_wire = 1;                        
                        else
                            Xsamp.remove_vertex(xm.idx); %Line 21
                            V.add_vertex(xm.idx); %Line 22
                        end

                        E.add_edge(vm.idx, xm.idx); %Line 23
                        xm.parent_idx = vm.idx;
                        xm.cost_from_parent = c_true;
                        xm.cost_from_start = vm.cost_from_start + xm.cost_from_parent;
                        S.add_element(xm);
                        vm.children_set = [vm.children_set; xm.idx];
                        S.add_element(vm);
                        if (re_wire == 1)
                            update_subgraph(xm.idx, S, V, E);                     
                        end

                    end
                end
            end
        else        
            Qe.empty(); % Line 27
        end
    end
    E_hash = container_set(edge_element.empty());
end

end

% recursive function to 
function update_subgraph(x_idx, S, V, E)
    x = S.get_element(x_idx);
    x_parent = S.get_element(x.parent_idx);
    x.cost_from_start =  x_parent.cost_from_start + x.cost_from_parent;
    S.add_element(x);
    for children = x.children_set'
        update_subgraph(children, S, V, E);
    end
end