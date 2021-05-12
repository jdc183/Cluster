function newgrid = floodfill(grid,start)
    nneesesswwnw = [1 1 0 -1 -1 -1 0 1; 0 1 1 1 0 -1 -1 -1];
    front = start;%The pixels on the border of the explored territory
    newgrid = grid;
    while size(front,2)>0
        newFront = [];
        for n = 1:size(front,2)
            p = front(:,n);
            w = size(grid,1);
            h = size(grid,2);
            neighbors = nneesesswwnw;
            for k = 1:8 %For each neighbor
                ptemp = p+neighbors(:,k);
                %Check if neighbor is within bounds and unoccupied
                if(ptemp(1) <= w && ptemp(1) >= 1 && ptemp(2) <= h ...
                && ptemp(2) >= 1 && newgrid(ptemp(1),ptemp(2)) == 1)
                    newFront = [newFront ptemp];
                end
            end
            newgrid(p(1),p(2)) = 2;
        end    
    front = newFront;
    end
end

