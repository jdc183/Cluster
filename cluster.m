hold off
figure(1)
hold off
max_clusters = 10;
num_clusters = floor(max_clusters*rand())+1; %Number of clusters to create
field_size = 100;

xc = field_size*rand(1,num_clusters)+1; %The true centroid of each cluster
yc = field_size*rand(1,num_clusters)+1;

pcd = []; %Variable to store the point cloud
for n=1:num_clusters
    npts = floor(abs(normrnd(100,20)));%Number of points in this cluster
    
    % Add normally distributed points around each centroid to the pcd
    pcd = [pcd [xc(n)+normrnd(0,1,[1,npts]);yc(n)+normrnd(0,2,[1,npts])]];
end

sz=size(pcd,2);
pcd = pcd(:,randperm(sz));%Shuffle the points


xmax = max(pcd(1,:));
ymax = max(pcd(2,:));
xmin = min(pcd(1,:));
ymin = min(pcd(2,:));
voxelres = 1;

plot(pcd(1,:),pcd(2,:),'r*');
hold on

%% Floodfill method
%Convert point cloud to occupancy grid
grid = voxelize(pcd,voxelres);
centroids = [];
while ~isempty(find(grid==1,1))
    %Find each contiguous region
    [r,c]=find(grid==1,1,'first');
    grid = floodfill(grid,[r;c]);
    tempgrid = grid==2;
    %Convert it back to a point cloud
    tempcloud = pclize(tempgrid,xmin,ymin,voxelres);
    if size(tempcloud,2) > 5 %Minimum size for valid cluster
        %Find the centroid of the downsampled cluster
        centroid = mean(tempcloud,2);
        centroids = [centroids centroid];
        
        figure(1)
        plot(tempcloud(1,:),tempcloud(2,:),'s')
        plot(centroid(1),centroid(2),'gx')
    end
    %Remove it from the grid
    grid(grid==2)=0;
end
nclusters = size(centroids,2);
dists = ones(nclusters,sz);
%%
%Compute distances to each point from each centroid
for n=1:nclusters
    dists(n,:) = vecnorm(pcd-centroids(:,n));
end

[d,i]=min(dists);
centroids = [];
for n=1:nclusters
    figure(2);
    %Plot the points closest to centroid n
    plot(pcd(1,i==n),pcd(2,i==n),'*');
    hold on
    %Find the real centroid of these points
    centroid = mean(pcd(:,i==n),2);
    centroids = [centroids centroid];
end
plot(centroids(1,:),centroids(2,:),'g*')

% figure(1)
% plot(centroids(1,:),centroids(2,:),'bx')
% hold on
% imagesc(voxelize(pcd,voxelres))

%% Centroid hypothesis method
for a=1:10%1:max_clusters
    nclusters=num_clusters;
    centroids = pcd(:,1:nclusters);
             
    dists = ones(nclusters,sz);
    
    for n=1:nclusters
        dists(n,:) = vecnorm(pcd-centroids(:,n));
    end
    
    [d,i]=min(dists);
    %
    figure(3)
    for n=1:nclusters
        plot(pcd(1,i==n),pcd(2,i==n),'*');
        hold on
    end
    plot(centroids(1,:),centroids(2,:),'g*');
    drawnow
    %
    centroids = [];
    for n=1:nclusters
        centroid = mean(pcd(:,i==n),2);
        centroids = [centroids centroid];
        plot(pcd(1,i==n),pcd(2,i==n),'*');
    end
    
    plot(centroids(1,:),centroids(2,:),'g*');
    drawnow
    a=a;
end