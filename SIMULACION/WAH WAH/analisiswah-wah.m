clear;clc;
xn1 = load('AUDIOS\guitarra_limpia.txt');
xn2 = load('AUDIOS\guitarra_wahwah.txt');
fm = 44100;
Tm = 1/fm;
N1 = length(xn1);
n = 0:Tm:(N1-1)*Tm;
nbits = 24;


figure(1);
specgram(xn1,256,fm);
title("ESPECTROGRAMA DE LA SEÑAL ORIGINAL");
grid;
figure(2)
specgram(xn2,256,fm);
title("ESPECTROGRAMA DEl EFECTO WAHWAH FPGA");
grid;




