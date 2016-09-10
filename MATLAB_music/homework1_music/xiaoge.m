clear all; close all; clc;
load envelope.mat;
load frequency.mat;

%合成乐曲为清华校歌前四小节
%简谱为1 13 5 5 | 6 1 5 5 | 3 3 53 1 | 6 13 5 -
%从F大调改为Eb大调

frequency_step = frequency_step/K^2;
length = 32;
xg = [8,8,8,10,12,12,12,12 , 13,13,8,13,12,12,12,12 , 10,10,10,10,12,10,8,8 , 6,6,8,10,12,12,12,12];
parameter = [1 , 0.2 , 0.3];
f = [1;2;3];
t1_xg = 1 : length * Fs/4;
%第一小节
t1_xg(1 : Fs/2) = (1 : Fs/2) * 2/Fs;
t1_xg(Fs/2 + 1 : Fs * 3/4) = (1 : Fs/4) * 4/Fs;
t1_xg(Fs * 3/4 + 1: Fs) = (1 : Fs/4) * 4/Fs;
t1_xg(Fs + 1 : Fs * 3/2) = (1 : Fs/2) * 2/Fs;
t1_xg(Fs * 3/2 + 1 : 2 * Fs) = (1 : Fs/2) * 2/Fs;
%第二小节
t1_xg(2 * Fs + 1 : 2 * Fs + Fs/2) = (1 : Fs/2) * 2/Fs;
t1_xg(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4) = (1 : Fs/4) * 4/Fs;
t1_xg(2 * Fs + Fs * 3/4 + 1: 3 * Fs) = (1 : Fs/4) * 4/Fs;
t1_xg(3 * Fs + 1 : 3 * Fs + Fs/2) = (1 : Fs/2) * 2/Fs;
t1_xg(3 * Fs + Fs/2 +1 : 4 * Fs) = (1 : Fs/2) * 2/Fs;
%第三小节
t1_xg(4 * Fs + 1 : 4 * Fs + Fs/2) = (1 : Fs/2) * 2/Fs;
t1_xg(4 * Fs + Fs/2 + 1 : 5 * Fs) = (1 : Fs/2) * 2/Fs;
t1_xg(5 * Fs + 1 : 5 * Fs + Fs * 1/4) = (1 : Fs/4) * 4/Fs;
t1_xg(5 * Fs + Fs * 1/4 + 1: 5 * Fs + Fs/2) = (1 : Fs/4) * 4/Fs;
t1_xg(5 * Fs + Fs/2 + 1 : 6 * Fs) = (1 : Fs/2) * 2/Fs;
%第四小节
t1_xg(6 * Fs + 1 : 6 * Fs + Fs/2) = (1 : Fs/2) * 2/Fs;
t1_xg(6 * Fs + Fs/2 + 1 : 6 * Fs + Fs * 3/4) = (1 : Fs/4) * 4/Fs;
t1_xg(6 * Fs + Fs * 3/4 + 1 : 7 * Fs) = (1 : Fs/4) * 4/Fs;
t1_xg(7 * Fs + 1 : 8 * Fs) = (1 : Fs) * 1/Fs;
%第一小节
y1_xg(1 : Fs/2) = parameter * sin(2 * 2 * pi * frequency_step(xg(1)) * f * t1_xg(1 : Fs/2));
y1_xg(Fs/2 + 1 : Fs * 3/4) = parameter * sin(2 * pi * frequency_step(xg(3)) * f * t1_xg(Fs/2 + 1 : Fs * 3/4));
y1_xg(Fs * 3/4 + 1 : Fs) = parameter * sin(2 * pi * frequency_step(xg(4)) * f * t1_xg(Fs * 3/4 + 1 : Fs));
y1_xg(Fs + 1 : Fs * 3/2) = parameter * sin(2 * 2 * pi * frequency_step(xg(5)) * f * t1_xg(Fs + 1 : Fs * 3/2));
y1_xg(Fs * 3/2 + 1 : 2 * Fs) = parameter * sin(2 * 2 * pi * frequency_step(xg(5)) * f * t1_xg(Fs * 3/2 + 1 : 2 * Fs));
%第二小节
y1_xg(2 * Fs + 1 : 2 * Fs + Fs/2) = parameter * sin(2 * 2 * pi * frequency_step(xg(9)) * f *t1_xg(2 * Fs + 1 : 2 * Fs + Fs/2));
y1_xg(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4) = parameter * sin(2 * pi * (2 * frequency_step(8)) * f * t1_xg(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4));
y1_xg(2 * Fs + Fs * 3/4 + 1: 3 * Fs) = parameter * sin(2 * pi * frequency_step(xg(12)) * f * t1_xg(2 * Fs + Fs * 3/4 + 1: 3 * Fs));
y1_xg(3 * Fs + 1 : 4 * Fs) = parameter * sin(2 * 2 * pi * frequency_step(xg(13)) * f * t1_xg(3 * Fs + 1 : 4 * Fs));
%第三小节
y1_xg(4 * Fs + 1 : 5 * Fs) = parameter * sin(2 * 2 * pi * frequency_step(xg(17)) * f * t1_xg(4 * Fs + 1 : 5 * Fs));
y1_xg(5 * Fs + 1 : 5 * Fs + Fs * 1/4) = parameter * sin(2 * pi * frequency_step(xg(21)) * f * t1_xg(5 * Fs + 1 : 5 * Fs + Fs * 1/4));
y1_xg(5 * Fs + Fs * 1/4 + 1: 5 * Fs + Fs/2) = parameter * sin(2 * pi * frequency_step(xg(22)) * f * t1_xg(5 * Fs + Fs * 1/4 + 1: 5 * Fs + Fs/2));
y1_xg(5 * Fs + Fs/2 + 1 : 6 * Fs) = parameter * sin(2 * 2 * pi * frequency_step(xg(23)) * f * t1_xg(5 * Fs + Fs/2 + 1 : 6 * Fs));
%第四小节
y1_xg(6 * Fs + 1 : 6 * Fs + Fs/2) = parameter * sin(2 * 2 * pi * frequency_step(xg(25)) * f * t1_xg(6 * Fs + 1 : 6 * Fs + Fs/2));
y1_xg(6 * Fs + Fs/2 + 1 : 6 * Fs + Fs * 3/4) = parameter * sin(2 * pi * frequency_step(xg(27)) * f *  t1_xg(6 * Fs + Fs/2 + 1 : 6 * Fs + Fs * 3/4));
y1_xg(6 * Fs + Fs * 3/4 : 7 * Fs) = parameter * sin(2 * pi * frequency_step(xg(28)) * f * t1_xg(6 * Fs + Fs * 3/4 : 7 * Fs));
y1_xg(7 * Fs + 1 : 8 * Fs) = parameter * sin(4 * 2 * pi * frequency_step(xg(29)) * f * t1_xg(7 * Fs + 1 : 8* Fs));
%第一小节
y1_xg(1 : Fs/2) = y1_xg(1 : Fs/2) .* exp_envelope_four;
y1_xg(Fs/2 + 1 : Fs * 3/4) = y1_xg(Fs/2 + 1 : Fs * 3/4) .* exp_envelope_eight;
y1_xg(Fs * 3/4 + 1 : Fs) = y1_xg(Fs * 3/4 + 1 : Fs) .* exp_envelope_eight;
y1_xg(Fs + 1 : Fs * 3/2) = y1_xg(Fs + 1 : Fs * 3/2) .* exp_envelope_four;
y1_xg(Fs * 3/2 + 1 : 2 * Fs) = y1_xg(Fs * 3/2 + 1 : 2 * Fs) .* exp_envelope_four;
%第二小节
y1_xg(2 * Fs + 1 : 2 * Fs + Fs/2) = y1_xg(2 * Fs + 1 : 2 * Fs + Fs/2) .* exp_envelope_four;
y1_xg(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4) = y1_xg(2 * Fs + Fs/2 + 1 : 2 * Fs + Fs * 3/4) .* exp_envelope_eight;
y1_xg(2 * Fs + Fs * 3/4 + 1: 3 * Fs) = y1_xg(2 * Fs + Fs * 3/4 + 1: 3 * Fs) .* exp_envelope_eight;
y1_xg(3 * Fs + 1 : 3 * Fs + Fs/2) = y1_xg(3 * Fs + 1 : 3 * Fs + Fs/2) .* exp_envelope_four;
y1_xg(3 * Fs + Fs/2 + 1 : 4 * Fs) = y1_xg(3 * Fs + Fs/2 + 1 : 4 * Fs) .* exp_envelope_four;
%第三小节
y1_xg(4 * Fs + 1 : 4 * Fs + Fs/2) = y1_xg(4 * Fs + 1 : 4 * Fs + Fs/2) .* exp_envelope_four;
y1_xg(4 * Fs + Fs/2 + 1 : 5 * Fs) = y1_xg(4 * Fs + Fs/2 + 1 : 5 * Fs) .* exp_envelope_four;
y1_xg(5 * Fs + 1 : 5 * Fs + Fs * 1/4) = y1_xg(5 * Fs + 1 : 5 * Fs + Fs * 1/4) .* exp_envelope_eight;
y1_xg(5 * Fs + Fs * 1/4 + 1: 5 * Fs + Fs/2) = y1_xg(5 * Fs + Fs * 1/4 + 1: 5 * Fs + Fs/2) .* exp_envelope_eight;
y1_xg(5 * Fs + Fs/2 + 1 : 6 * Fs) = y1_xg(5 * Fs + Fs/2 + 1 : 6 * Fs) .* exp_envelope_four;
%第四小节
y1_xg(6 * Fs + 1 : 6 * Fs + Fs/2) = y1_xg(6 * Fs + 1 : 6 * Fs + Fs/2) .* exp_envelope_four;
y1_xg(6 * Fs + Fs/2 + 1 : 6 * Fs + Fs * 3/4) = y1_xg(6 * Fs + Fs/2 + 1 : 6 * Fs + Fs * 3/4) .* exp_envelope_eight;
y1_xg(6 * Fs + Fs * 3/4 +1 : 7 * Fs) = y1_xg(6 * Fs + Fs * 3/4 +1 : 7 * Fs) .* exp_envelope_eight;
y1_xg(7 * Fs + 1 : 8 * Fs) = y1_xg(7 * Fs + 1 : 8 * Fs) .* exp_envelope_two;
%合成音乐
plot(1:length * Fs/4,y1_xg);
sound(y1_xg , Fs);