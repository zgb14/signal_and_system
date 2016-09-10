clear all;close all;clc;
load guitar.mat;
Fs=8000;
T=1/Fs;
% temp=wave2proc;
temp=zeros(24300,1);
for i=1:100
    temp((i-1)*243+1:i*243)=wave2proc;
end
length=length(temp);
t=(0:length-1)*T;
NFFT=2^nextpow2(length);
F=fft(temp,NFFT)/length;
f=Fs/2*linspace(0,1,NFFT/2+1);
plot(f,2*abs(F(1:NFFT/2+1)));