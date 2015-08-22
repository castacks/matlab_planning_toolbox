classdef general_queue < handle
    %VERTEX_QUEUE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        pq
        max_item = 10000;
    end
    
    methods
        function obj = general_queue()
            obj.pq = pq_create(obj.max_item); 
        end
        
        function push(obj, idx, cost)
            priority = -cost;
            for i = 1:length(cost)
                pq_push(obj.pq, idx(i), priority(i));
            end
        end
        
        function idx = pop(obj)
            idx = pq_pop(obj.pq);
        end
        
        function [idx, pr] = top(obj)
            if (pq_size(obj.pq) == 0)
                idx = [];
                c = -inf;
            else
                [idx,c] = pq_top(obj.pq);
            end
            pr = -c;
        end
        
        function flag = is_empty(obj)
            flag = (pq_size(obj.pq) == 0);
        end
        
        function empty(obj)
            pq_delete(obj.pq);
            obj.pq = pq_create(obj.max_item);
        end
    end
    
end