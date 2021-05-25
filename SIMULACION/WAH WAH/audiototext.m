clear;clc;

%CARGA DE AUDIO WAV
[s, fs] = audioread('AUDIOS\guitarra_wahwah.wav');
s = s';

Tm= 1/fs;
l = length(s);
n = 0:Tm:l*Tm-Tm;
nBits = 24;

#figure(1);
#plot(n,s,'*-r*');
%axis([0.82 0.822 -0.5 0.5]);
save('AUDIOS\guitarra_wahwah.txt','s','-ascii');
#sound(s,fs,nBits);

