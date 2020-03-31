%ctrlT: number of control periods
%binit: natural infectivity, i.e., infectivity with no controls in place
%Kall: pid control params, [k_proportional, k_integral, k_differential]
function sim (binit, Kall, ctrlT)
time = [0]; %time units series
number = [0.99,0.001,0]; %column wise: S, I, R
desired=0.04; %value of I control system will shoot for
simTime = 400;
lengthT = simTime/ctrlT; %length of control period
error=[0]; %error computed once every control period
beta = [binit]; %beta computed once every control period
delay=0.3*ctrlT; %delay between infection and control units of lengthT, factor is in units of simTime
for k=1:ctrlT
  %numerically solve ode within control period (ctrlT)
  %initial condition for new section is end of last section
  [t,x]=SIR(lengthT,beta(end),number(end,:));
  time = [time t+time(end)]; %append to rest of data
  number = [number; x];

  if k>delay
   %crude digital PID - controlling number of infected
    %number(end-1,2): delay from plant action to control of one lengthT, simulate test delay
    error = [error, desired - number(end-delay,2)];
    integral = error(end)*lengthT;
    diff =(error(end)-error(end-1))/lengthT;
    betactrl = Kall(1)*error(end)+Kall(2)*integral+Kall(3)*diff;
    beta = [beta beta(1)+betactrl]; %bias beta around the natural infectivity
    
    %floor and ceiling on beta
    %no way to make beta below 0
    %undesirable to raise the infectivity above normal (except by vaccination)
    if(beta(end)<0)
      beta(end)=0;
    endif
    if(beta(end)>beta(1))
      beta(end)=beta(1);
    endif
  endif
endfor

%plotting results
subplot(2, 1, 1)
hold on
plot(time, number(:,1))
ax=plotyy(time, number(:,3), time,  number(:,2));
xlabel ("time");
ylabel (ax(1), "S, R");
ylabel (ax(2), "Infected");
legend('S', 'R', 'I')
str = sprintf("initial infection rate = %d,  recovery rate = 0.05",beta(1)); 
title(str)
hold off
subplot(2, 1, 2)
plot([ones(delay,1)*beta(1) zeros(delay,1) ; beta' error'])
axis([0 ctrlT -beta(1) beta(1)])
legend('beta','error')
str=sprintf("Kp = %d, Ki = %d, Kd = %d, # control period = %d",Kall(1),Kall(2),Kall(3),ctrlT);
title(str)

%TODO: gain scheduling, family of PID controller, linearize SIR model
endfunction

%when beta is high -> infect all pop, requires large change in beta (down to zero)
%smaller beta -> not complete infection, requires smaller changes in beta (down 50%)
%done TODO: delay in testing and control
%TODO: model of pop control _> beta mapping
%TODO: good digital implementation of PID control, IIR or FIR?