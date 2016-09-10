close all;clear all;clc;
load hall.mat;
load JpegCoeff.mat;
test=double(hall_gray(105:120,153:168));
temp=test-128;
trans=dct2(test);
minus=128*dct2(ones(16,16));
final=idct2(trans-minus);




