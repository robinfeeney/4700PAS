% This example shows how to calculate and plot both the
% fundamental TE and TM eigenmodes of an example 3-layer ridge
% waveguide using the full-vector eigenmode solver.  
% shows Transvere Electric and Transvers Magnetic Modes  
set(0, 'DefaultFigureWindowStyle', 'docked')

for i = 1:10 %loop to help adjust ridge index
    % Refractive indices:
    n1 = 3.34;          % Lower cladding
    n2(i) = 3.44 - (i-1)*0.015          % Core
    n3 = 1.00;          % Upper cladding (air)
    
    % Layer heights:
    h1 = 2.0;           % Lower cladding
    h2 = 1.3;           % Core thickness
    h3 = 0.5;           % Upper cladding
    
    % Horizontal dimensions:
    rh = 1.1;           % Ridge height
    rw = 1.0;           % Ridge half-width
    side = 1.5;         % Space on side
    
    % Grid size:
    dx = 0.1;        % grid size (horizontal) (multiplied 0.0125 by 8)
    dy = 0.1;        % grid size (vertical)   (multiplied 0.0125 by 8)
    
    lambda = 1.55;      % vacuum wavelength
    nmodes = 1;         % number of modes to compute
    
    [x,y,xc,yc,nx,ny,eps,edges] = waveguidemesh([n1,n2(i),n3],[h1,h2,h3],rh,rw,side,dx,dy); % instead of n2 its n2(i)
    
    % First consider the fundamental TE mode:
    
    [Hx,Hy,neffTE(i)] = wgmodes(lambda,n2(i),1,dx,dy,eps,'000A'); % instead of n2 its n2(i)
    
    fprintf(1,'neff = %.6f\n',neff);

    figure(i);
    subplot(1,2,1);
    contourmode(x,y,Hx(:,:,1));
    title(['Hx (TE mode: ' num2str(i) ')']); xlabel('x'); ylabel('y'); 
    % for v = edges, line(v{:}); end
    
    subplot(1,2,2);
    contourmode(x,y,Hy(: ,:,1));
    title(['Hy (TE mode: ' num2str(i) ')']); xlabel('x'); ylabel('y'); 
    % for v = edges, line(v{:}); end
end

figure
plot(n2, neffTE); hold on
xlabel('ridge index');
ylabel('Neff');
legend('TE');