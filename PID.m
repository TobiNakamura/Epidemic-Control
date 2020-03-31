function ctrl = PID(input, output, param)
  %first principle PID
  %integral = (input(end)+input(end-1))*0.5*param(4);
  %diff =(input(end)-input(end-1))/param(4);
  %ctrl = param(1)*input(end)+param(2)*integral+param(3)*diff;
  
  %good PID
  %https://msc.berkeley.edu/assets/files/PID/modernPID4-digitalPID.pdf
  %page 12
  ctrl = output(end-1)+param(3)*input(end)+param(2)*input(end-1)+param(1)*input(end-2);
endfunction