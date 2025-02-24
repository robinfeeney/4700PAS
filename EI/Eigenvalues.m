set(0, 'DefaultFigureWindowStyle', 'docked')
nx = 50; % change maximum value for x
ny = 50; % change maximum value for y
V = zeros(nx, ny); % initialize our array to be all 0s
G = sparse(nx*ny, nx*ny); % initialize sparse matrix
Inclusion = 0; % set to 1 to introduce inclusion in region specified on line 16
for i = 1:nx   %loop from 1 to x boundary
    for j = 1:ny %loop from 1 to y boundary
        n = j + (i-1) * ny;
        V(i,j) = n;
        if ((i == 1 && j == 1) || (i == nx && j == ny)) % if on the boundary
            G(n, n) = 1;
        else
            %V(i+1, j) + V(i-1,j) + V(i, j+1) + V(i,j-1) = (4)(V(i,j))
            %finite difference ^^
            if (Inclusion && (i > 10 && i < 20 && j > 10 && j < 20))
                G(n,n) = -2;
            else
                G(n,n) = -4;
            end
            if i > 1
                G(n,n-nx) = 1;
            end
            if i < nx
                G(n,n+ny) = 1;
            end
            if  (j > 1 )
                G(n,n-1) = 1;
            end
            if (j < ny)
                G(n,n+1) = 1;
            end
        end
    end
end
figure('name','Matrix')
spy(G)
nmodes = 9;
[E, D] = eigs(G, nmodes, 'SM');
figure('name','EigenValues')
plot(diag(D), '*')
np = ceil(sqrt(nmodes));
figure('name','Modes')
for k=1:nmodes
    M = E(:,k);
    for i = 1:nx   %loop from 1 to x boundary
        for j = 1:ny %loop from 1 to y boundary
            n = j + (i-1)*nx;
            V(i,j) = M(n);
        end
        subplot(np,np,k), surf(V, 'linestyle','none')
        title(['EV = ' num2str(D(k,k))])
    end 
end