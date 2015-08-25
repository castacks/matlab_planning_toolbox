%% 
% Copyright (c) 2015 Carnegie Mellon University, Sanjiban Choudhury <sanjibac@andrew.cmu.edu>
%
% For License information please see the LICENSE file in the root directory.
%
%%

function [final_path, final_cost, log_data] = batch_sample_planner( start, goal, options )
%BITSTAR Summary of this function goes here
%   Detailed explanation goes here

%% Initialization

infty = inf;

%Functions
g_hat = options.g_hat;
h_hat = options.h_hat;
f_hat = @(v) g_hat(v) + h_hat(v);
c_hat = options.c_hat;
c = options.c;
g_t   = @(v) cell2mat({v.cost_from_start}');

%Visualizations
visualize = options.visualize;
visualize_delay = options.visualize_delay;

should_log = options.should_log;
max_iter = options.max_iter;
max_batches = options.max_batches;
max_time = options.max_time;
sampler = options.sampler;
succ_func = options.succ_func;


function c = vq_cost(v)
    if (isempty(v))
        c = infty;
    else
        c = g_t(v) + h_hat(v);
    end
end

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
Xsamp.add_vertex(v_goal.idx);

%% Line 2
Qe = general_queue();
Qv = general_queue();
Qv.push(V.get_idx(), vq_cost(S.get_element(V.get_idx())));
Vold = vertex_set(V); %Line 8

%% Line 3 - 27 main loop
batch = 0;
handle_set = [];
memo = -ones(5000,5000);
edge_being_cons = [];

timerval = tic;
log_data = [];
iter = 0;
num_collcheck = 0;
num_optimcalls = 0;

while(toc(timerval) < max_time && iter < max_iter)
    iter = iter + 1;
    
    if (visualize)
        handle_set = global_search_visualize(handle_set, S, V, Xsamp, goal_id, edge_being_cons);
        pause(visualize_delay);
    end

    if (should_log)
        log_data = [log_data; table(toc(timerval), iter, batch, S.num_elements(), V.num_vertex(), num_collcheck, num_optimcalls, g_t(S.get_element(goal_id)), ...
        'VariableNames', {'time', 'iter', 'batch', 'num_samples', 'num_vertices', 'num_collcheck', 'num_optimcalls', 'goal_cost'})];
    end
    
    if (Qe.is_empty() && Qv.is_empty())
        batch = batch + 1; 
        if (batch > max_batches)
            break;
        end
 
        if (batch > 1)
            %disp('done with batch')
            %pause
            thresh = g_t(S.get_element(goal_id));
            for x = S.get_element(V.get_idx());
                if (V.has_vertex(x.idx) && f_hat(x) > thresh)
                    if (x.parent_idx > 0)
                        cur_par = S.get_element(x.parent_idx);
                        cur_par.children_set = cur_par.children_set(cur_par.children_set ~= x.idx);
                        S.add_element(cur_par);
                    end
                    prune_subgraph(x.idx, f_hat, thresh, S, V, E, Xsamp, infty);
                end
            end
        end

        xs = Xsamp.get_idx(); % Line 5
        if (~isempty(xs))
            Xsamp.remove_vertex(xs(f_hat(S.get_element(xs)) >= g_t(S.get_element(goal_id))));
        end
        
        %Line 6
        thresh = g_t(S.get_element(goal_id));
        for x = S.get_element(V.get_idx());
            if (V.has_vertex(x.idx) && f_hat(x) > thresh)
                if (x.parent_idx > 0)
                    cur_par = S.get_element(x.parent_idx);
                    cur_par.children_set = cur_par.children_set(cur_par.children_set ~= x.idx);
                    S.add_element(cur_par);
                end
                prune_subgraph(x.idx, f_hat, thresh, S, V, E, Xsamp, infty);
            end
        end
        
        %%
        %Line 7        
        new_sample_set = sampler(g_t(S.get_element(goal_id)));
        for new_sample = new_sample_set
            new_sample.idx = S.get_next_idx();
            new_sample.parent_idx = 0;
            new_sample.cost_from_parent = infty;
            new_sample.cost_from_start = infty;
            S.add_element(new_sample);
            Xsamp.add_vertex(new_sample.idx);
        end

        Vold = vertex_set(V); %Line 8
       
        %%   
        Qv = general_queue(); 
        Qv.push(V.get_idx(),vq_cost(S.get_element(V.get_idx()))); %Line 9
    end
    
    % Line 11
    while (1)
        v_best = Qv.top();
        e_best = Qe.top();
        [ebest1, ebest2] = E_hash.get_element(e_best).get_edge();
        v_best_val = vq_cost(S.get_element(v_best));
        e_best_val = eq_cost(S.get_element(ebest1),S.get_element(ebest2));
        if v_best_val < e_best_val
            if (v_best == goal_id)
                %fprintf('Cost from goal %f\n', g_t(S.get_element(goal_id)));
                Qv.empty();
                Qe.empty();
                break;
            end
            %fprintf('Popping %d\n', v_best); 
            expand_vertex()
        else
            break;
        end
    end
    
    if (Qv.is_empty() && Qe.is_empty())
        continue;
    end
    
    e_idx = Qe.pop(); %Line 13, 14
    [e1, e2] = E_hash.get_element(e_idx).get_edge();
    vm = S.get_element(e1);
    xm = S.get_element(e2);
    edge_being_cons = [vm.state; xm.state];

    if (g_t(vm) + c_hat(vm, xm) + h_hat(xm) < g_t(S.get_element(goal_id))) % Line 15
        if (g_t(vm) + c_hat(vm, xm) < g_t(xm)) %Line 25 rewarped
            % Lets do collision checking
            if (memo(vm.idx, xm.idx)==-1)
                c_true = c(vm, xm);
                memo(vm.idx, xm.idx) = c_true;
                num_collcheck = num_collcheck + 1;
            else
                c_true = memo(vm.idx, xm.idx);
            end
            if g_hat(vm) + c_true + h_hat(xm) < g_t(S.get_element(goal_id)) %Line 16
                if g_t(vm) + c_true < g_t(xm) %Line 17
                    to_push = 0;
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
                        to_push = 1;
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
                    if (to_push)
                        Qv.push(xm.idx, vq_cost(xm));
                    end

                end
            end
        end
    else        
        Qe.empty(); % Line 27
        E_hash = container_set(edge_element.empty());
    end
end

final_cost = S.get_element(goal_id).cost_from_start;
final_path = global_search_path( S, goal_id );
if (~isempty(final_path))
    final_path(:,3) = [];
end

function expand_vertex()
    v = S.get_element(Qv.pop()); % Line 1
    Xnear = succ_func(v, Xsamp, S, V.num_vertex() + Xsamp.num_vertex());
    % Line 3
    for xn = Xnear
        if (g_hat(v) + c_hat(v, xn) + h_hat(xn) < g_t(S.get_element(goal_id)))
            if(memo(v.idx, xn.idx)==-1)
                edge_elem = edge_element(E_hash.get_next_idx(), v.idx, xn.idx);
                E_hash.add_element(edge_elem);
                Qe.push(edge_elem.idx, eq_cost(v,xn));
            end
        end
    end
    
    %% ADDITION
    if (~Vold.has_vertex(v.idx))
        Vnear = succ_func(v, V, S, V.num_vertex() + Xsamp.num_vertex());
        % Line 7
        for w = Vnear
            if (w.idx ~= v.idx && ...
                    w.parent_idx ~= v.idx && ... %safety check ;)
                    ~E.has_edge(v.idx, w.idx) && ...
                    g_hat(v) + c_hat(v, w) + h_hat(w) < g_t(S.get_element(goal_id)) && ...
                    g_t(v) + c_hat(v, w) < g_t(w))
                if(memo(v.idx, w.idx)==-1)
                    edge_elem = edge_element(E_hash.get_next_idx(), v.idx, w.idx);
                    E_hash.add_element(edge_elem);
                    Qe.push(edge_elem.idx, eq_cost(v,x));
                end
            end
        end
    end 
end

end

% recursive function to prune subgraph
function prune_subgraph(x_idx, f_hat, thresh, S, V, E, Xsamp, infty)
    if (~V.has_vertex(x_idx))
        return
    end
    x = S.get_element(x_idx);
    V.remove_vertex(x.idx);
    E.remove_all_parents(x.idx);
    x.parent_idx = 0;
    x.cost_from_parent = infty;
    x.cost_from_start = infty;
    children_set = x.children_set;
    x.children_set = [];
    S.add_element(x);
    if (f_hat(x) <= thresh)
        Xsamp.add_vertex(x.idx)
    end
    for children = children_set'
        prune_subgraph(children, f_hat, thresh, S, V, E, Xsamp, infty);
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