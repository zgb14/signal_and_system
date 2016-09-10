clear all;close all;clc;
load auto_data.mat;
Fs=8000;
test_sound=0;
for i=1:length(tune_fre)
    t=zeros(1,pat_length(i));
    t=(1:pat_length(i))/pat_length(i);
    temp=zeros(1,pat_length(i));
    temp=sin(2*pi*tune_fre(i)*t*(pat_length(i)/8000));
    test_sound=[test_sound,temp];
    if i==length(tune_fre)
        finish=length(y);
    else
        finish=position(i+1);
    end
    sound([y(position(i):finish)],Fs);
end
sound(test_sound,Fs);
