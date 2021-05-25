clear;clc;

lfo_min = 200;
lfo_max = 2000;
fm= 98000;

n1 = 200:20:780;
n2 = 800:40:1500;
n3 = 1550:50:2000;
n = [n1 n2 n3];
N = length(n);

a0 = zeros(1,N);
a1 = zeros(1,N);
a2 = zeros(1,N);
b1 = zeros(1,N);
b2 = zeros(1,N);

for j=1:N; 
[x,m] = iirbpf(n(j),fm,1.5);
a0(1,j) =  m(1);
a1(1,j) =  m(2);
a2(1,j) =  m(3);
b1(1,j) =  x(1);
b2(1,j) =  x(2);
end

a0 = a0';
a1 = a1';
a2 = a2';
b1 = b1';
b2 = b2';
