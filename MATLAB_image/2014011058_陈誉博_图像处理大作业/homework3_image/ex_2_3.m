close all;clear all;clc;
load hall.mat;
[row,column]=size(hall_gray);
Image1=double(hall_gray);
Image2=double(hall_gray);
for i=1:(row/8)
    for j=1:(column/8)
        Image=double(hall_gray((i-1)*8+1:i*8,(j-1)*8+1:j*8));
        trans=dct2(Image-128*ones(8,8));
        trans1=trans;
        trans1(:,5:8)=0;
        trans2=trans;
        trans2(:,1:4)=0;
        Image1((i-1)*8+1:i*8,(j-1)*8+1:j*8)=idct2(trans1)+128*ones(8,8);
        Image2((i-1)*8+1:i*8,(j-1)*8+1:j*8)=idct2(trans2)+128*ones(8,8);
    end
end
figure;
subplot(1,2,1);
imshow(hall_gray);
axis square;
subplot(1,2,2);
imshow(uint8(Image1));
axis square;
figure;
subplot(1,2,1);
imshow(hall_gray);
axis square;
subplot(1,2,2);
imshow(uint8(Image2));
axis square;