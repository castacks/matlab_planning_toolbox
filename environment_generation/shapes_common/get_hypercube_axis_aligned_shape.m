function shape = get_hypercube_axis_aligned_shape(lb,width)

shape = get_blank_shape();
shape.name = 'hypercube_axis_aligned';
shape.data = [lb; width];

end
