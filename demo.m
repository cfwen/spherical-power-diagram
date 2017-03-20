load sphere.mat

% radius === 0, voronoi diagram
pd0 = spherical_power_diagram(vertex);

% generate some random radius
% radius should be too large, or some cell may vanish
radius = rand(size(vertex,1),1)*0.15;
pd = spherical_power_diagram(vertex,radius);

% plot
figure('Position',[580 400 1000 420]);
subplot(1,2,1)
trimesh(face,vertex(:,1),vertex(:,2),vertex(:,3),'EdgeColor',[36 169 225]/255)
hold on
plot_power_diagram(pd0);
title('voronoi diagram')
view(0,0)
axis([-1.1 1.1 -1.1 1.1 -1 1.1])
axis equal
axis off

subplot(1,2,2)
trimesh(face,vertex(:,1),vertex(:,2),vertex(:,3),'EdgeColor',[36 169 225]/255)
hold on
plot_power_diagram(pd);
title('power diagram')
view(0,0)
axis([-1.1 1.1 -1.1 1.1 -1 1.1])
axis equal
axis off