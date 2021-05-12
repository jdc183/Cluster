function grid = voxelize(pcd,dx)
    xmax = max(pcd(1,:));
    ymax = max(pcd(2,:));
    xmin = min(pcd(1,:));
    ymin = min(pcd(2,:));
    
    cmax = floor((xmax-xmin)/dx);% Number of columns
    rmax = floor((ymax-ymin)/dx);% Number of rows
    
    grid = zeros(rmax+1,cmax+1);
    
    for n=1:size(pcd,2)
        %Determine the grid square that each point occupies
        r=floor((pcd(1,n)-xmin)/dx)+1;
        c=floor((pcd(2,n)-ymin)/dx)+1;
        grid(r,c)=1;
    end
end

