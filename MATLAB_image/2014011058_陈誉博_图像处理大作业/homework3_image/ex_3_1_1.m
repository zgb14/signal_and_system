close all;clear all;clc;
load hall.mat;
information=double('signal and system');
% ASCII码中一共只有128种字符
% 所以对隐藏信息进行编码的时候将每个数字编码为7位
% 在隐藏信息之前添加一位表示隐藏信息的长度
information_code=[];
tempcode=double(dec2bin(length(information)))-48;
tempcode=[zeros(1,7-length(tempcode)),tempcode];
information_code=[information_code,tempcode];
for i=1:length(information)
    tempcode=double(dec2bin(information(i)))-48;
    tempcode=[zeros(1,7-length(tempcode)),tempcode];
    information_code=[information_code,tempcode];
end
save information.mat information_code;
[row,column]=size(hall_gray);
code_hidden=[];
image_hidden=zeros(row,column);
for i=1:row
    for j=1:column
        tempcode=double(dec2bin(hall_gray(i,j)))-48;
        tempcode=[zeros(1,8-length(tempcode)),tempcode];
        if (i-1)*8+j<=length(information_code)
            tempcode(8)=information_code((i-1)*8+j);
        end
        code_hidden=[code_hidden,tempcode];
        image_hidden(i,j)=bin2dec(char(tempcode+48));
    end
end
image_hidden=uint8(image_hidden);
save hidden.mat code_hidden image_hidden;
subplot(1,2,1);imshow(hall_gray);
subplot(1,2,2);imshow(image_hidden);
