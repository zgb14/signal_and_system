close all;clear all;clc;
load envelope.mat;
%%prepare process
%the basic frequency is f_low_do
f_low_do=174.61;
%K is the step parameter between two frequencies
K=2^(1/12);
%Fs is potrate
Fs=8000;
frequency=zeros(2,12);
frequency(1,1)=f_low_do;
for i=2:12
frequency(1,i)=frequency(1,i-1)*K;
end
i=1:12;
frequency(2,i)=frequency(1,i)*2;

f_basic=frequency(2,1);
frequency_step=zeros(1,14);
for j=1:2
i=1:3;
frequency_step(1,i+7*(j-1))=frequency(j,2*i-1);
frequency_step(1,4+7*(j-1))=frequency(j,6);
i=5:7;
frequency_step(1,i+7*(j-1))=frequency(j,2*i-2);
end
%下面代表音调的矩阵中每一个元素代表一个八分音符
length=16;
dfh=[12,12,12,13,9,9,9,9,8,8,8,6,9,9,9,9];

parameter6=[1,0.3514,0.2202,0.1707,0.1235,0,0.2287];
parameter8=[1,0.1403,0.3535,0,0,0,0];
parameter9=[1,0.3920,0,0.1093,0,0,0.1408];
parameter12=[1,2.6253,0.7736,0.9474,0,0.1064,0];
parameter13=[1,0.4217,0,0.1687,0,0,0];
f=[1;2;3;4;5;6;7];

t1=1:length*Fs/4;
t1(1:Fs/2)=(1:Fs/2).*2/Fs;
t1(Fs/2+1:Fs*3/4)=(1:Fs/4).*4/Fs;
t1(Fs*3/4+1:Fs)=(1:Fs/4).*4/Fs;
t1(Fs+1:2*Fs)=(1:Fs).*1/Fs;
t1(2*Fs+1:2*Fs+Fs/2)=(1:Fs/2).*2/Fs;
t1(2*Fs+Fs/2+1:2*Fs+Fs*3/4)=(1:Fs/4).*4/Fs;
t1(2*Fs+Fs*3/4+1:2*Fs+Fs)=(1:Fs/4).*4/Fs;
t1(2*Fs+Fs+1:2*Fs+2*Fs)=(1:Fs).*1/Fs;
y1(1:Fs/2)=parameter12*sin(2*0.5*f*pi*frequency_step(12)*t1(1:Fs/2)).*exp_envelope_four;
y1(Fs/2+1:Fs*3/4)=parameter12*sin(2*0.25*f*pi*frequency_step(12)*t1(Fs/2+1:Fs*3/4)).*exp_envelope_eight;
y1(Fs*3/4+1:Fs)=parameter13*sin(2*0.25*f*pi*frequency_step(13)*t1(Fs*3/4+1:Fs)).*exp_envelope_eight;
y1(Fs+1:2*Fs)=parameter9*sin(2*f*pi*frequency_step(9)*t1(Fs+1:2*Fs)).*exp_envelope_two;

y1(2*Fs+1:2*Fs+Fs/2)=parameter8*sin(2*0.5*f*pi*frequency_step(8)*t1(2*Fs+1:2*Fs+Fs/2)).*exp_envelope_four;
y1(2*Fs+Fs/2+1:2*Fs+Fs*3/4)=parameter8*sin(2*0.25*f*pi*frequency_step(8)*t1(2*Fs+Fs/2+1:2*Fs+Fs*3/4)).*exp_envelope_eight;
y1(2*Fs+Fs*3/4+1:2*Fs+Fs)=parameter6*sin(2*0.25*f*pi*frequency_step(6)*t1(2*Fs+Fs*3/4+1:2*Fs+Fs)).*exp_envelope_eight;
y1(2*Fs+Fs+1:2*Fs+2*Fs)=parameter9*sin(2*f*pi*frequency_step(9)*t1(2*Fs+Fs+1:2*Fs+2*Fs)).*exp_envelope_two;
plot(y1);
sound(y1,Fs);