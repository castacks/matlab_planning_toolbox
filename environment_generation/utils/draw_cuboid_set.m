function draw_cuboid_set( cuboid_set )
%DRAW_CUBOID_SET Summary of this function goes here
%   Detailed explanation goes here

for i = 1:size(cuboid_set,1)
    DrawCuboid(cuboid_set(i,4:6)', cuboid_set(i,1:3)', [0;0;0], 'r', 1.0); 
end

end

