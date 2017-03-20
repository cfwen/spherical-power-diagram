function plot_power_diagram(pd)
hold on
for i = 1:length(pd.cell)
    pi = pd.dual_points(pd.cell{i},:);
    plot3(pi(:,1),pi(:,2),pi(:,3),'b-');
end
axis equal
