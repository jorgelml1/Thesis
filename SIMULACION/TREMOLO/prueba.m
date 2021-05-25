clear;clc;

fm = 512;
Tm = 1/fm;

n = 0:Tm:0.5-Tm;
N = length(n);
nbits = 24;

f1 = 2;

lfo = -0.5*cos(2*pi*f1*n);
lfo = 0.5+lfo;
#lfo = 2*lfo;

limite = 1;
a = zeros(1,N);

for t = 1:N
  
  if t >= 64
    
    a(1,t) = 1;
   
  else
  
    a(1,t) = lfo(1,t);   
  end
  
end
a = 256*a;
figure(1)
hold on
plot(n,a);

a = a';

x3 = 0.5*sawtooth(2*pi*f1*n,0.5);
x3 = 0.5+x3;
x3 = 256*x3;
plot(n,x3);
