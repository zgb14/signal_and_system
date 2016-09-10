clear all; close all; clc;
load dongfanghong_gai.mat;
y2 = resample(y1,1000,1059);
sound([y1 , y2] , Fs);
