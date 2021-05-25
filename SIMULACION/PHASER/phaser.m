clear;clc;
xn = load('AUDIOS\guitarra_riff.txt');
fm = 44100;
Tm = 1/fm;
N1 = length(xn);
n = 0:Tm:(N1-1)*Tm;
nbits = 24;

f1 = 1;
lfo_min = 200;
lfo_max = 2000;


lfo = sawtooth(2*pi*f1*n,0.5);
lfo = 0.5*(lfo_max-lfo_min)*lfo+(lfo_min+lfo_max)/2; 

y = zeros(1,N1);

for j=3:N1; 
[b,a] = iirnotch(lfo(j),0.5); 
y(j) = b(1)*xn(j)+b(2)*xn(j-1)+b(3)*xn(j-2)-a(1)*y(j-1)-a(2)*y(j-2);
end


figure(1);
subplot(2,1,1);
plot(n,xn,'r');
title("SEÑAL ORIGINAL");
grid;
subplot(2,1,2);
plot(n,y,'b');
title("EFECTO PHASER");
grid;

figure(3)
specgram(xn,256,fm);

figure(4)
specgram(y,256,fm);


