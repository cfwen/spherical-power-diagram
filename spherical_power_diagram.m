function pd = spherical_power_diagram(points,radius)

eps = 1e-6;

% points must be on unit sphere, radius must be 0 <= radius < pi/2
pl = sqrt(dot(points,points,2));
if abs(max(pl)-1)>eps || abs(1-min(pl))>eps
    error('points must be on unit sphere')    
end
% normalize points in case some points slightly deviate from unit sphere
points = points./[pl,pl,pl];

% radius must be less than pi/2 and greater or equal than 0
% if radius === 0, then we get voronoi diagram
if ~exist('radius','var')
    radius = zeros(size(points,1),1);
end
if max(radius)-pi>=eps || min(radius)<0
    error('radius must satisfy 0 <= radius < pi/2')
end

cr = cos(radius);
hp = [cr,cr,cr].*points;
hpl2 = dot(hp,hp,2);
dm2 = min(hpl2);
if dm2 < eps
    warning('plane too near to the origin')
end

% pmax = 2^28*0.98;
% scale = pmax*sqrt(dmin2)./hpl2;
% hp2 = hp.*[scale,scale,scale];

hp2 = hp./[hpl2,hpl2,hpl2];
face = convhull(hp2);

ind = false(size(points,1),1);
ind(face) = true;
if sum(ind) < size(points,1)
    warning('inappropriate radius configuration, some cells vanished');
end

dual_points = zeros(size(face));

a1 = hp(face(:,1),:);
a2 = hp(face(:,2),:);
a3 = hp(face(:,3),:);
aj11 = a2(:,2).*a3(:,3)-a2(:,3).*a3(:,2);
aj12 = a1(:,3).*a3(:,2)-a1(:,2).*a3(:,3);
aj13 = a1(:,2).*a2(:,3)-a1(:,3).*a2(:,2);
aj21 = a2(:,3).*a3(:,1)-a2(:,1).*a3(:,3);
aj22 = a1(:,1).*a3(:,3)-a1(:,3).*a3(:,1);
aj23 = a1(:,3).*a2(:,1)-a1(:,1).*a2(:,3);
aj31 = a2(:,1).*a3(:,2)-a2(:,2).*a3(:,1);
aj32 = a1(:,2).*a3(:,1)-a1(:,1).*a3(:,2);
aj33 = a1(:,1).*a2(:,2)-a1(:,2).*a2(:,1);
b1 = dot(a1,a1,2);
b2 = dot(a2,a2,2);
b3 = dot(a3,a3,2);
dual_points(:,1) = aj11.*b1+aj12.*b2+aj13.*b3;
dual_points(:,2) = aj21.*b1+aj22.*b2+aj23.*b3;
dual_points(:,3) = aj31.*b1+aj32.*b2+aj33.*b3;

dpl = sqrt(dot(dual_points,dual_points,2));
pd.points = points;
pd.radius = radius;
pd.dual_points = dual_points./[dpl,dpl,dpl];
dt = triangulation(face,hp2);
pd.cell = vertexAttachments(dt);
pd.face = face;
