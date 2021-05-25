#GENEDADOR DE COSENO

clear;clc;
fm = 44100; # Frecuencia de muestreo en Hz.
Tm = 1/fm; # Periodo de muestreo en segundos
f1 = 100;
f2 = 150;
f3 = 200;
f4 = 300;
f5 = 400;
f6 = 600;
f7 = 800;
f8 = 1200;
f9 = 1600;
f10 = 2400;
f11 = 3200;
n = 0:Tm:1-Tm;
N = length(n); 
k = 0:fm/N:fm-(fm/N);

s1 = cos(2*pi*f1*n);
s2 = cos(2*pi*f2*n);
s3 = cos(2*pi*f3*n);
s4 = cos(2*pi*f4*n);
s5 = cos(2*pi*f5*n);
s6 = cos(2*pi*f6*n);
s7 = cos(2*pi*f7*n);
s8 = cos(2*pi*f8*n);
s9 = cos(2*pi*f9*n);
s10 = cos(2*pi*f10*n);
s11 = cos(2*pi*f11*n);

s13 = 0.06*s1 + 0.06*s2 + 0.06*s3 + 0.06*s4 + 0.06*s5 + 0.06*s6 + 0.06*s7 + 0.06*s8 + 0.06*s9 + 0.06*s10 + 0.06*s11;
s13 = s13;

y = fft(s13);
yp = log(abs(y)/sqrt(N));
#yp = abs(y);

figure(1);
subplot(2,1,1);
plot(n,s13,'r');
title("SEÑAL MULTI FRECUENCIA");
grid;
subplot(2,1,2);
plot(k,yp,'b');
title("ESPECTRO DE LA SEÑAL GENERADA");
axis([0 5000 -20 5]);


audiowrite ("senal.wav", s13, fm)

