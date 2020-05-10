beta=0.04; %infection coefficient
gamma=0.7; %recovery coefficient
gamma_m=10; %mean recovery time
T=50; %simulation time
n=100; %population
cluster=4;
rend=n/cluster;
peak=zeros(rend,1);
peaktime=zeros(rend,1);
avgsse=zeros(rend,1);
DD=zeros(rend,1);
for r=1:rend
  [A,~]=randomModularGraph(n,cluster,0.1,r);
  [x, mean, sse, meansse, k] = net_sim(beta, gamma, gamma_m, T, n, A);
  [peak(r), peaktime(r)]=max(mean(:,2));
  avgsse(r)=sum(sum((mean(:,2)-x).^2,2)/k)/T; %average of sse between mean and run over all runs
  DD(r)=diffDist(A);
end

%todo: error bars on peak and peaktime boxplot cell deliminate so that k can be dynamic
%todo: investigate run to run variation. some peak/peaktime are near zero. might be due to initial infected persons position in graph. solve by infecting many people randomly throughout graph and larger n
%todo: check that randomModularGraph actually generates graphs with consistant statistics
figure
scatter(DD,peak);
xlabel("Diffusion Distance")
ylabel("infection peak number") 

figure
scatter(1:rend,peak);
xlabel("cluster ratio")
ylabel("infection peak number") 

figure
scatter(1:rend,peaktime);
xlabel("cluster ratio")
ylabel("infection peak time")

figure
scatter(1:rend,avgsse);
xlabel("cluster ratio")
ylabel("mean of sse between mean and run")
title("something about spread of runs")