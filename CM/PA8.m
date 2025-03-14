Is = 0.01e-12; 
Ib = 0.1e-12;
Vb = 1.3;
Gp = 0.1;

V = linspace(-1.95, 0.7, 200);  
I = Is * (exp(1.2 * V / 0.025) - 1) + Gp * V - Ib * (exp(1.2 * (-(V + Vb)) / 0.025) - 1);

noise = 0.2 * I;
noiseValues = noise .* (rand(1, length(V)) - 0.5);
I = I + noiseValues;

%creating polynomial fits
p4 = polyfit(V, I, 4);
p8 = polyfit(V, I, 8);
poly4 = polyval(p4, V);
poly8 = polyval(p8, V);

% Plot the noisy data
figure;
subplot(4,2,1);
plot(V, I);
hold on
title('Current vs Voltage');
plot(V, poly4, 'r-');
plot(V, poly8, 'y-');
xlabel('V');
ylabel('I');
legend('data', 'poly4', 'poly8');

subplot(4,2,2);
semilogy(V, abs(I));
hold on;
semilogy(V, abs(poly4), 'r-');
semilogy(V, abs(poly8), 'y-');
title('Poly Fit');
xlabel('V');
ylabel('I (abs)');
legend('data', 'poly4', 'poly8');


% A is Is, B is Gp, C is Ib and D is Vb
fo2 = fittype('A.*(exp(1.2*x/25e-3)-1) + 0.1.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)', 'independent', 'x', ...
    'coefficients', {'A', 'C'});
fo3 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+1.3))/25e-3)-1)', 'independent', 'x', ...
    'coefficients', {'A', 'B', 'C'});
fo4 = fittype('A.*(exp(1.2*x/25e-3)-1) + B.*x - C*(exp(1.2*(-(x+D))/25e-3)-1)', 'independent', 'x', ...
    'coefficients', {'A', 'B', 'C', 'D'});

ff1 = fit(V', I', fo2);
ff2 = fit(V', I', fo3);
ff3 = fit(V', I', fo4);


% Plot the fits
subplot(4,2,3);
plot(V, I, 'b');
hold on;
plot(V, feval(ff1, V), 'r-');
plot(V, feval(ff2, V), 'b-');
plot(V, feval(ff3, V), 'g-');
title('Nonlinear Fit');
xlabel('V');
ylabel('I');
legend('data', 'fit1', 'fit2', 'fit3');


subplot(4,2,4);
semilogy(V, abs(I), 'b');
hold on;
semilogy(V, abs(feval(ff1, V)), 'r-');
semilogy(V, abs(feval(ff2, V)), 'b-');
semilogy(V, abs(feval(ff3, V)), 'g-');
title('Nonlinear Fit');
xlabel('V');
ylabel('I (abs)');
legend('data', 'fit1', 'fit2', 'fit3');


inputs = V.';
targets = I.';

hiddenLayerSize = 10;
net = fitnet(hiddenLayerSize);
net.divideParam.trainRatio = 70/100;
net.divideParam.valRatio = 15/100;
net.divideParam.testRatio = 15/100;
[net,tr] = train(net,inputs,targets);
outputs = net(inputs);
errors = gsubtract(outputs,targets);
performance = perform(net,targets,outputs);
view(net)
Inn = outputs;

subplot(4,2,5);
plot(V, I, 'b'); 
hold on;
plot(V, Inn, 'r-');
xlabel('V');
ylabel('I');
title('Neural Network Fit');
legend('data', 'nn');

subplot(4,2,6);
semilogy(V, abs(I), 'b'); 
hold on;
semilogy(V, abs(Inn), 'r-');
xlabel('V');
ylabel('I (abs)');
title('Neural Network Fit');
legend('data', 'nn');


m = fitrgp(V.', I.');
Ig = predict(m, V.');

subplot(4,2,7);
plot(V, I, 'b');
hold on;
plot(V, Ig, 'b-');
xlabel('V');
ylabel('I');
legend('data', 'rgp');
title('GPR Fit');


subplot(4,2,8);
semilogy(V, abs(I), 'b');
hold on;
semilogy(V, abs(Ig), 'b-');
xlabel('V');
ylabel('I (abs)');
legend('data', 'rgp');
title('GPR Fit');


plotbrowser;