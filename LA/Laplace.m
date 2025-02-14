set(0, 'DefaultFigureWindowStyle', 'docked')

nx = 100; %change maximum value for x
ny = 100; % change maximum value for y 
ni = 10000; % change number of iterations
npause = 50; % change how often to update graph
V = zeros(nx, ny); %initialize our array to be all 0s

SidesToZero = false; % flag for if sides should be at 0 - set to true or false
for k = 1:ni % loop through all the iterations
    for i = 1:nx % loop from 1 to x boundary 
        for j = 1:ny % loop from 1 to y boundary
            if (i==1) % check if i is at left boundary 
                V(i,j) = 1; % if it is, set to 1
            elseif (i==nx) % check if i is at right boundary 
                V(i,j) = 0; % if it is, set to 0
            elseif (j==1) % check if j is at a boundary
                if(SidesToZero == true) % check if we want sides to be at 0
                    V(i,j) = 0; % if so, set to 0
                else 
                    V(i,j) = V(i,j+1); % if not, set V(i, j+1)
                end
            elseif(j==ny) %same thing here but with other boundary
                if(SidesToZero == true)
                    V(i,j) = 0;
                else
                    V(i,j) = V(i, j-1);
                end
            else % if neither of those are true, use the finite difference form of laplace equation
                V(i,j) = (V(i+1,j) + V(i-1,j) + V(i,j+1) + V(i, j-1))/4;
            end
        end
    end

    if mod(k,npause) == 0
        surf(V') % plots V every 50 iterations
        %imboxfilt(V', 3)
        pause(0.05)
    end
end

[Ex, Ey] = gradient(V); % used for second figure

figure
quiver(-Ey',Ex',1) % change this one to make figure 2 better to see - increasing 3rd value helps a lot