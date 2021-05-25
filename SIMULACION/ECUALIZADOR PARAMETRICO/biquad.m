clear;clc;
xn = load('AUDIOS\guitarra_riff.txt');
fm = 44100;
Tm = 1/fm;
N1 = length(xn);
n = 0:Tm:(N1-1)*Tm;
nbits = 24;
k = 0:fm/N1:fm-(fm/N1);

an = [0.004892583833893165, 0.00978516766778633,  0.004892583833893165];
bn = [1,  -1.9118664040428421, 0.9314367393784148]; 

xn2 = filter(an,bn,xn);   #x y señal

sound(xn,fm,nbits);
sound(xn2,fm,nbits);



y1 = fft(xn);
y2 = fft(xn2);
yp1 = log(abs(y1)/sqrt(N1));
yp2 = log(abs(y2)/sqrt(N1));

figure(1);
hold on
plot(n,xn,";SEÑAL ORIGINAL;");
plot(n,xn2,";SEÑAL FILTRADA;");
title("BIQUAD 1KHZ");
grid;


#axis([0 4000 -20 5]);


figure(2);
hold on
plot(k,yp1,";SEÑAL ORIGINAL;");
plot(k,yp2,";SEÑAL FILTRADA;");
title("BIQUAD FFT 1KHZ");
grid;
axis([0 20000 -20 5]);

