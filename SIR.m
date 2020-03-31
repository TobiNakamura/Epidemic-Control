%taken from:
%http://epirecip.es/epicookbook/chapters/sir/octave
function [t, x] = SIR(T, b, x0)
function xdot = sir_eqn(x,t,beta)
    % Parameter values
    %beta=0.1; %try and control infection rate
    mu=0.05; %assuming recovery rate cannot be controlled

    % Define variables
    s = x(1);
    y = x(2);
    r = x(3);

    % Define SIR ODEs
    ds=-beta*s*y;
    dy=beta*s*y-mu*y;
    dr=mu*y;

    % Return gradients
    xdot = [ds,dy,dr];
endfunction

t = linspace(0, T, 200);
x = lsode(@(x,t) sir_eqn (x, t, b),x0, t); %ode solver
endfunction