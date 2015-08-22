clc
clear
close all

bbox = [-2000 2000 -2000 2000 0 300 -Inf Inf];
figure;
axis(bbox);
grid on;
%cuboid_set = []; % x y z sx sy sz
load temp.mat
%% Lets put in tiny buildings every where eh!
%[prex, prey] = meshgrid(-2000:500:2000, -2000:500:2000);
%cuboid_set = [reshape(prex, [],1) reshape(prey, [],1) 25*ones(size(prex,1)*size(prex,2),1) 100*ones(size(prex,1)*size(prex,2),1) 100*ones(size(prex,1)*size(prex,2),1)  50*ones(size(prex,1)*size(prex,2),1)];
draw_cuboid_set( cuboid_set );
while(1)
    title('Drag rect');
    view(0, 90);
    final_rect = getrect(gca);
    cuboid_set = [cuboid_set; final_rect(1)+0.5*final_rect(3) final_rect(2)+0.5*final_rect(4) 0 final_rect(3) final_rect(4) 0];
    draw_cuboid_set( cuboid_set );
    while (1)
        %h = inputdlg('height');
        h  = input('Enter height: ');
        cuboid_set(end,3) = 0.5*h;
        cuboid_set(end,6) = h;
        title('Feel free to look around');
        draw_cuboid_set( cuboid_set );
        pause;
        title('Right click if happy');
        [~,~,button] = ginput(1);
        if (button == 3)
            break;
        end
    end
end
