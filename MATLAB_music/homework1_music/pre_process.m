clear all; close all; clc;
load guitar.mat;
temp=resample(realwave,10,1);
average=zeros(243,10);
for i=1:10
    average(:,i)=temp((i-1)*243+1:i*243);
end
temp2=zeros(243,1);
for i=1:243
    temp2(i,1)=sum(average(i,:))/10;
end
temp3=zeros(2430,1);
for i=1:10
    temp3((i-1)*243+1:i*243)=temp2;
end
temp4=resample(temp3,1,10);
figure;
subplot(2,1,1);
plot(temp4);
subplot(2,1,2);
plot(wave2proc);
