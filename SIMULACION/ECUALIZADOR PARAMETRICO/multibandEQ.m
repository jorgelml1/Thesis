clear;clc;
xn = load('AUDIOS\senal.txt');
fm = 44100;
Tm = 1/fm;
N1 = length(xn);
n = 0:Tm:(N1-1)*Tm;
nbits = 24;
k = 0:fm/N1:fm-(fm/N1);

##FILTRO 400Hz +9dB

an1 = [ 1.0034459300234884,  -1.9929690292668722,  0.9927639661823761];
bn1 = [1,  -1.9929690292668722, 0.9962098962058644]; 
xn2 = filter(an1,bn1,xn);   #x y señal

##FILTRO 3200 +9dB

an2 = [ 1.026301247352829,  -1.769736961739273,    0.9447705803677049];
bn2 = [1,  -1.769736961739273,   0.971071827720534]; 
xn3 = filter(an2,bn2,xn2);  

sound(xn,fm,nbits);
sound(xn3,fm,nbits);



y1 = fft(xn);
y2 = fft(xn3);
yp1 = log(abs(y1)/sqrt(N1));
yp2 = log(abs(y2)/sqrt(N1));

figure(1);
subplot(2,1,1);
plot(n,xn,'r');
title("SEÑAL ORIGINAL");
axis([0 0.03 -0.4 0.8]);
grid;
subplot(2,1,2);
plot(n,xn,'b');
title("ECUALIZADOR MULTIBANDA FFT");
axis([0 0.03 -0.4 0.8]);
grid;


figure(2);
subplot(2,1,1);
plot(k,abs(y1),'r');
title("SEÑAL ORIGINAL");
axis([0 5000 0 5000]);
grid;
subplot(2,1,2);
plot(k,abs(y2),'b');
title("ECUALIZADOR MULTIBANDA FFT");
grid;
axis([0 5000 0 5000]);