clear;clc;
xn = load('AUDIOS\guitarra_riff.txt');
fm = 44100;
Tm = 1/fm;
N1 = length(xn);
n = 0:Tm:(N1-1)*Tm;
nbits = 24;

f1 = 12;



lfo = 0.375*sin(2*pi*f1*n);
lfo = 0.625+lfo;

y = xn.*lfo;


figure(1);
subplot(2,1,1);
plot(n,xn,'r');
title("SEÑAL ORIGINAL");
grid;
subplot(2,1,2);
plot(n,y,'b');
title("EFECTO TREMOLO");
grid;



