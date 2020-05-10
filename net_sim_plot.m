clear all
%close all
addpath("octave-networks-toolbox/")
filename="cluser ratio 1"
n=100;
[A,~]=randomModularGraph(n,4,0.1,25);

beta=0.04; %infection coefficient
gamma=0.7; %recovery coefficient
gamma_m=10; %mean recovery time
T=50; %simulation time
[x, mean, sse, meansse, k] = net_sim(beta, gamma, gamma_m, T, n, A);

figure
plot(x)
hold on
plot(mean(:,2), '--', "linewidth", 5)
axis([0 T 0 n])
str = sprintf("\\beta=%d, \\gamma=%d, \\gamma_m=%d, network file \"%s\"",beta,gamma,gamma_m,filename); 
title(str)
ylabel("Number of Intected")
xlabel("Sim Time")

figure
semilogy(sse(1:k-1))
hold on
semilogy(meansse(1:k-1),'--')
axis([1 k-1])
ylabel("Sum of squares error between previous and new mean")
xlabel("Number of runs")