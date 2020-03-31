function ctrl = IIR(input, output, param)
  ctrl = input(end) + exp(param)*output(end-1);
endfunction