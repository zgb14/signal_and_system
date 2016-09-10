clear all; close all; clc;
load dongfanghong.mat;
%frequency_step 是频率参考矩阵
%t1是每个音符的采样时间
%y1是音乐信号
%Fs是采样率

%linear_envelope_eight是八分音符的包络
%linear_envelope_four是四分音符的包络
%linear_envelop_two是二分音符的包络

length_eight = Fs/4;
length_four = Fs/2;
length_two = Fs;
linear_envelope_eight(1 : length_eight/8) = linspace(0 , 1 , length_eight/8);
linear_envelope_eight(length_eight/8 + 1 : length_eight/4) = linspace(1 , 0.8, length_eight/8);
linear_envelope_eight(length_eight/4 + 1 : length_eight * 7/8) = linspace(0.8 , 0.8 , length_eight *5/8);
linear_envelope_eight(length_eight * 7/8 + 1 : length_eight) = linspace(0.8 , 0 , length_eight * 1/8);

linear_envelope_four(1 : length_four/8) = linspace(0 , 1 , length_four/8);
linear_envelope_four(length_four/8 + 1 : length_four/4) = linspace(1 , 0.8, length_four/8);
linear_envelope_four(length_four/4 + 1 : length_four * 7/8) = linspace(0.8 , 0.8 , length_four *5/8);
linear_envelope_four(length_four * 7/8 + 1 : length_four) = linspace(0.8 , 0 , length_four * 1/8);

linear_envelope_two(1 : length_two/8) = linspace(0 , 1 , length_two/8);
linear_envelope_two(length_two/8 + 1 : length_two/4) = linspace(1 , 0.8, length_two/8);
linear_envelope_two(length_two/4 + 1 : length_two * 7/8) = linspace(0.8 , 0.8 , length_two * 5/8);
linear_envelope_two(length_two * 7/8 + 1 : length_two) = linspace(0.8 , 0 , length_two * 1/8);

exp_envelope_eight = linear_envelope_eight .* exp(-2 * ((1 : length_eight) ./ length_eight));
exp_envelope_four = linear_envelope_four .* exp(-2 * ((1 : length_four)) ./ length_four);
exp_envelope_two = linear_envelope_two .* exp(-2 * ((1 : length_two)) ./ length_two);

% y1(1 : Fs/2) = y1(1 : Fs/2) .* linear_envelope_four;
% y1(Fs/2 + 1 : Fs * 3/4) = y1(Fs/2 + 1 : Fs * 3/4) .* linear_envelope_eight;
% y1(Fs * 3/4 + 1 : Fs) = y1(Fs * 3/4 + 1 : Fs) .* linear_envelope_eight;
% y1(Fs + 1 : 2 * Fs) = y1(Fs + 1 : 2 * Fs) .* linear_envelope_two;
% 
% y1(2 * Fs + 1 : 2 * Fs + Fs/2) = y1(2 * Fs + 1 : 2 * Fs + Fs/2) .* linear_envelope_four;
% y1(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4) = y1(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4) .* linear_envelope_eight;
% y1(2 * Fs + Fs * 3/4 + 1 : 2 * Fs + Fs) = y1(2 * Fs + Fs * 3/4 + 1 : 2 * Fs + Fs) .* linear_envelope_eight;
% y1(2 * Fs + Fs + 1 : 2 * Fs + 2 * Fs) = y1(2 * Fs + Fs + 1 : 2 * Fs + 2 * Fs) .* linear_envelope_two;

y1(1 : Fs/2) = y1(1 : Fs/2) .* exp_envelope_four;
y1(Fs/2 + 1 : Fs * 3/4) = y1(Fs/2 + 1 : Fs * 3/4) .* exp_envelope_eight;
y1(Fs * 3/4 + 1 : Fs) = y1(Fs * 3/4 + 1 : Fs) .* exp_envelope_eight;
y1(Fs + 1 : 2 * Fs) = y1(Fs + 1 : 2 * Fs) .* exp_envelope_two;

y1(2 * Fs + 1 : 2 * Fs + Fs/2) = y1(2 * Fs + 1 : 2 * Fs + Fs/2) .* exp_envelope_four;
y1(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4) = y1(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4) .* exp_envelope_eight;
y1(2 * Fs + Fs * 3/4 + 1 : 2 * Fs + Fs) = y1(2 * Fs + Fs * 3/4 + 1 : 2 * Fs + Fs) .* exp_envelope_eight;
y1(2 * Fs + Fs + 1 : 2 * Fs + 2 * Fs) = y1(2 * Fs + Fs + 1 : 2 * Fs + 2 * Fs) .* exp_envelope_two;

%plot(1 : 4 * Fs , y1);
sound(y1 , Fs);
save dongfanghong_gai.mat;
save envelope.mat exp_envelope_eight exp_envelope_four exp_envelope_two;