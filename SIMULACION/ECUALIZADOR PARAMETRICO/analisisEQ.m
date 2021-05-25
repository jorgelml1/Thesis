clear;clc;
xn1 = load('AUDIOS\guitarra_limpia.txt');
xn2 = load('AUDIOS\guitarra_eq1.txt');
xn3 = load('AUDIOS\guitarra_eq2.txt');
fm = 44100;
Tm = 1/fm;
N1 = length(xn1);
n = 0:Tm:(N1-1)*Tm;
nbits = 24;
k = 0:fm/N1:fm-(fm/N1);


y1 = fft(xn1);
y2 = fft(xn2);
y3 = fft(xn3);
yp1 = log(abs(y1)/sqrt(N1));
yp2 = log(abs(y2)/sqrt(N1));
yp3 = log(abs(y3)/sqrt(N1));

figure(1);
subplot(3,1,1);
plot(n,xn1,'r');
title("SEÑAL ORIGINAL");
grid;
subplot(3,1,2);
plot(n,xn2,'b');
title("ECUALIZADOR 1");
grid;
subplot(3,1,3);
plot(n,xn3,'g');
title("ECUALIZADOR 2");
grid;


figure(2);
subplot(3,1,1);
plot(k,yp1,'r');
title("SEÑAL ORIGINAL FFT");
axis([0 5000 -20 -5]);
grid;

subplot(3,1,2);
plot(k,yp2,'b');
title("ECUALIZADOR 1 FFT");
axis([0 5000 -20 -5]);
grid;

subplot(3,1,3);
plot(k,yp3,'g');
title("ECUALIZADOR 2  FFT");
axis([0 5000 -20 -5]);
grid;
