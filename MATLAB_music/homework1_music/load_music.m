clear all; close all; clc;
load guitar.mat;
y=wavread('fmt.wav');
plot(1:length(realwave),realwave);
plot(1:length(wave2proc),wave2proc);
sound(wave2proc,8000);