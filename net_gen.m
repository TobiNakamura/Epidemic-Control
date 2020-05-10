addpath("octave-networks-toolbox/")
n=100; %population size
A=zeros(n,n);
%A+=sparse([1 1 2],[2 3 3],[1 1 1],n,n); %cluster 1
%A+=sparse([4 4 5],[5 6 6],[1 1 1],n,n); %cluster 2
%A(1,4)=1; %link
A=A+A'; %symmetric matrix
A=[0 1; 1 0];
ratio=5;
[A,~]=randomModularGraph(n,4,0.1,ratio);
W=A.*rand(n,n);
%adj2file(A,"r5_adj.txt")
A=ones(n,n)-eye(n,n);
