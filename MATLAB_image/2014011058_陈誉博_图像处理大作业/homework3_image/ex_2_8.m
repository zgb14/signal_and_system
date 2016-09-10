close all;clear all;clc;
load hall.mat;
load JpegCoeff.mat;
[row,column]=size(hall_gray);
image=zeros(8,8);
trans=zeros(8,8);
value=zeros(8,8);
result=zeros(64,row/8*column/8);
for i=1:row/8
    for j=1:column/8
        image=double(hall_gray((i-1)*8+1:i*8,(j-1)*8+1:j*8))-128*ones(8,8);
        trans=dct2(image);
        value=round(trans./QTAB);
        result(1,(i-1)*column/8+j)=value(1,1);
        result(2:64,(i-1)*column/8+j)=ZigZag(value);
    end
end
disp(result);
save result.mat result;