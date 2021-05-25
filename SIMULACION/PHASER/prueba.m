clear;clc;

fm = 96000;
Tm = 1/fm;

n = 0:Tm:1-Tm;
nbits = 24;

f1 = 1;

lfo_min = 200;
lfo_max = 2000;

lfo = sawtooth(2*pi*f1*n,0.5);
lfo = 0.5*(lfo_max-lfo_min)*lfo+(lfo_min+lfo_max)/2; 