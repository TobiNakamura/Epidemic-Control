## Copyright (C) 2020 Tobi
## 
## This program is free software; you can redistribute it and/or modify it
## under the terms of the GNU General Public License as published by
## the Free Software Foundation; either version 3 of the License, or
## (at your option) any later version.
## 
## This program is distributed in the hope that it will be useful,
## but WITHOUT ANY WARRANTY; without even the implied warranty of
## MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
## GNU General Public License for more details.
## 
## You should have received a copy of the GNU General Public License
## along with this program.  If not, see <http://www.gnu.org/licenses/>.

## Author: Tobi
## Created: 2020-04-27

function [x, mean, sse, meansse, k] = net_sim(beta, gamma, gamma_m, T, n, A)

x=zeros(T,100); %plot number of infecteds over time
sse=zeros(100,1); %sum of square errors
mean=zeros(T,2); %mean from run-to-run, 1st column is prev mean, 2nd is current
meansse=zeros(100,1);
k=1;
do
  I=zeros(n,1); %infected population, binary
  I(2)=1; %initial condition infected
  S=~I; %susceptible population, binary
  It=I; %time a person has been infected, natural number
  
  for t=1:T
    %contraction probability given that individual is susceptible
    contract = (beta*A*I > rand(n,1)).*S; 
    %recovery probability given that individual is infected
    recover = (gamma*(It-gamma_m) > rand(n,1)).*I;
    S += -contract;
    I += contract - recover;
    It+= I;
    x(t,k)=sum(I);
  end
  mean(:,2)=sum(x,2)/k; %mean from run-to-run
  sse(k) = sum(diff(mean,1,2).^2); %sse of mean from run-to-run
  meansse(k)=sum(sse(((k>20)*(k-20)+(k<=20)*1):k))/21; %moving average window = 10
  mean(:,1)=mean(:,2); %update prev mean
  k+=1;
until meansse(k-1) < (n*0.05)^2 % terminate at 95% CI