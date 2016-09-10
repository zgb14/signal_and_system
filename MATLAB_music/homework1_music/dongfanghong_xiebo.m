clear all;close all; clc;
load dongfanghong_gai.mat;

%y1_2是二次谐波分量
%y1_3是三次谐波分量
%parameter是各次谐波分量的大小
parameter = [ 1 ; 0.2 ; 0.3];

y1_2(1 : Fs/2) = sin(2 * 2 * 2 * pi * frequency_step(dfh(1)) * t1(1 : Fs/2));
y1_2(Fs/2 + 1 : Fs * 3/4) = sin(2 * 2 * pi * frequency_step(dfh(3)) * t1(Fs/2 + 1 : Fs * 3/4));
y1_2(Fs * 3/4 + 1 : Fs) = sin(2 * 2 * pi * frequency_step(dfh(4)) * t1(Fs * 3/4 + 1 : Fs));
y1_2(Fs + 1 : 2 * Fs) = sin(2 * 4 * 2 * pi * frequency_step(dfh(5)) * t1(Fs + 1 : 2 * Fs));

y1_2(2 * Fs + 1 : 2 * Fs + Fs/2) = sin(2 * 2 * 2 * pi * frequency_step(dfh(9)) * t1(2 * Fs + 1 : 2 * Fs + Fs/2));
y1_2(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4) = sin(2 * 2 * pi * frequency_step(dfh(11)) * t1(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4));
y1_2(2 * Fs + Fs * 3/4 + 1 : 2 * Fs + Fs) = sin(2 * 2 * pi * frequency_step(dfh(12)) * t1(2 * Fs + Fs * 3/4 + 1 : 2 * Fs + Fs));
y1_2(2 * Fs + Fs + 1 : 2 * Fs + 2 * Fs) = sin(2 * 4 * 2 * pi * frequency_step(dfh(13)) * t1(2 * Fs + Fs + 1 : 2 * Fs + 2 * Fs));

y1_3(1 : Fs/2) = sin(3 * 2 * 2 * pi * frequency_step(dfh(1)) * t1(1 : Fs/2));
y1_3(Fs/2 + 1 : Fs * 3/4) = sin(3 * 2 * pi * frequency_step(dfh(3)) * t1(Fs/2 + 1 : Fs * 3/4));
y1_3(Fs * 3/4 + 1 : Fs) = sin(3 * 2 * pi * frequency_step(dfh(4)) * t1(Fs * 3/4 + 1 : Fs));
y1_3(Fs + 1 : 2 * Fs) = sin(3 * 4 * 2 * pi * frequency_step(dfh(5)) * t1(Fs + 1 : 2 * Fs));

y1_3(2 * Fs + 1 : 2 * Fs + Fs/2) = sin(3 * 2 * 2 * pi * frequency_step(dfh(9)) * t1(2 * Fs + 1 : 2 * Fs + Fs/2));
y1_3(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4) = sin(3 * 2 * pi * frequency_step(dfh(11)) * t1(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4));
y1_3(2 * Fs + Fs * 3/4 + 1 : 2 * Fs + Fs) = sin(3 * 2 * pi * frequency_step(dfh(12)) * t1(2 * Fs + Fs * 3/4 + 1 : 2 * Fs + Fs));
y1_3(2 * Fs + Fs + 1 : 2 * Fs + 2 * Fs) = sin(3 * 4 * 2 * pi * frequency_step(dfh(13)) * t1(2 * Fs + Fs + 1 : 2 * Fs + 2 * Fs));

y1_2(1 : Fs/2) = y1_2(1 : Fs/2) .* exp_envelope_four;
y1_2(Fs/2 + 1 : Fs * 3/4) = y1_2(Fs/2 + 1 : Fs * 3/4) .* exp_envelope_eight;
y1_2(Fs * 3/4 + 1 : Fs) = y1_2(Fs * 3/4 + 1 : Fs) .* exp_envelope_eight;
y1_2(Fs + 1 : 2 * Fs) = y1_2(Fs + 1 : 2 * Fs) .* exp_envelope_two;

y1_2(2 * Fs + 1 : 2 * Fs + Fs/2) = y1_2(2 * Fs + 1 : 2 * Fs + Fs/2) .* exp_envelope_four;
y1_2(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4) = y1_2(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4) .* exp_envelope_eight;
y1_2(2 * Fs + Fs * 3/4 + 1 : 2 * Fs + Fs) = y1_2(2 * Fs + Fs * 3/4 + 1 : 2 * Fs + Fs) .* exp_envelope_eight;
y1_2(2 * Fs + Fs + 1 : 2 * Fs + 2 * Fs) = y1_2(2 * Fs + Fs + 1 : 2 * Fs + 2 * Fs) .* exp_envelope_two;

y1_3(1 : Fs/2) = y1_3(1 : Fs/2) .* exp_envelope_four;
y1_3(Fs/2 + 1 : Fs * 3/4) = y1_3(Fs/2 + 1 : Fs * 3/4) .* exp_envelope_eight;
y1_3(Fs * 3/4 + 1 : Fs) = y1_3(Fs * 3/4 + 1 : Fs) .* exp_envelope_eight;
y1_3(Fs + 1 : 2 * Fs) = y1_3(Fs + 1 : 2 * Fs) .* exp_envelope_two;

y1_3(2 * Fs + 1 : 2 * Fs + Fs/2) = y1_3(2 * Fs + 1 : 2 * Fs + Fs/2) .* exp_envelope_four;
y1_3(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4) = y1_3(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4) .* exp_envelope_eight;
y1_3(2 * Fs + Fs * 3/4 + 1 : 2 * Fs + Fs) = y1_3(2 * Fs + Fs * 3/4 + 1 : 2 * Fs + Fs) .* exp_envelope_eight;
y1_3(2 * Fs + Fs + 1 : 2 * Fs + 2 * Fs) = y1_3(2 * Fs + Fs + 1 : 2 * Fs + 2 * Fs) .* exp_envelope_two;

y =y1+0.2*y1_2+0.3*y1_3;
sound(y , Fs);