function [b,a] = iirbpf(Fc, Fs, Q)


K = tan(pi*Fc/Fs); 
 
norm = 1 / (1 + K / Q + K * K);
a0 = K / Q * norm;
a1 = 0;
a2 = -a0;
b1 = 2 * (K * K - 1) * norm;
b2 = (1 - K / Q + K * K) * norm;

a = [a0, a1, a2];
b = [b1,b2];
end           
          
   