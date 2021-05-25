function [nr, dr] = iirnotch(f,Q)
%#codegen
lfo = f;
Fs = 44100;
Wo = (2*lfo/Fs)*pi;
BW = (2*lfo/Fs/Q)*pi;
Ab = 3;
Gb = 10^(-Ab/20);
beta = (sqrt(1-Gb.^2)/Gb)*tan(BW/2);
gain = 1/(1+beta);
b = gain*[1 -2*cos(Wo) 1];
a = [1 -2*gain*cos(Wo) (2*gain-1)];
dr =(a(2:end))';
nr = b';
end