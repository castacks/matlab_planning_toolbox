function map = convert_shape_array_to_map( shapes_array, bbox, resolution )
%CONVERT_SHAPE_ARRAY_TO_MAP Summary of this function goes here
%   Detailed explanation goes here

for count = 1:length(shapes_array)
    rectangle_array(count).low = shapes_array(count).data(1:2);
    rectangle_array(count).high = shapes_array(count).data(1:2) + shapes_array(count).data(3:4);
end

map = rectangle_maps( bbox, rectangle_array, resolution);

end

