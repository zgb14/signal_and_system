close all;clear all;clc;
load hall.mat;
[row,column]=size(hall_gray);
Image1=zeros(row,column);
Image2=zeros(row,column);
Image3=zeros(row,column);
for i=1:(row/8)
    for j=1:(column/8)
        Image=double(hall_gray((i-1)*8+1:i*8,(j-1)*8+1:j*8));
        trans=dct2(Image-128*ones(8,8));
        trans1=rot90(trans);
        trans2=rot90(trans,2);
        trans3=trans';
        Image1((i-1)*8+1:i*8,(j-1)*8+1:j*8)=idct2(trans1)+128*ones(8,8);
        Image2((i-1)*8+1:i*8,(j-1)*8+1:j*8)=idct2(trans2)+128*ones(8,8);
        Image3((i-1)*8+1:i*8,(j-1)*8+1:j*8)=idct2(trans3)+128*ones(8,8);
    end
end
figure;
subplot(1,2,1);
imshow(hall_gray);
subplot(1,2,2);
imshow(uint8(Image1));
figure;
subplot(1,2,1);
imshow(hall_gray);
subplot(1,2,2);
imshow(uint8(Image2));
figure;
subplot(1,2,1);
imshow(hall_gray);
subplot(1,2,2);
imshow(uint8(Image3));