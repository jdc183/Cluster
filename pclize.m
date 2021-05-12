function pcd = pclize(grid,xmin,ymin,dx)
    [rs,cs]=find(grid);
    rs = rs';
    cs = cs';
    pcd = [(rs-1)*dx+xmin;(cs-1)*dx+ymin];
end