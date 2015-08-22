function connected = check_coll_traj_map( p_start, p_end, map  )
%CHECK_COLL_TRAJ_MAP Summary of this function goes here
idx = world_traj_to_grid( p_start, p_end, map );
c = map.table(sub2ind(size(map.table), idx(:,1), idx(:,2)));

if (any(~c))
    connected = 0;
else
    connected = 1;
end

end

