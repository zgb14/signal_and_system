close all;clear all;clc;
load hall.mat;
[height,width,channel]=size(hall_color);
Image=double(hall_color);
for i=1:height/8
    if mod(i,2)==1
        for j=1:2:width/8
            Image((i-1)*8+1:(i)*8,(j-1)*8+1:(j)*8,1:3)=0;
        end
    else
        for j=1:2:width/8-1
            Image((i-1)*8+1:(i)*8,j*8+1:(j+1)*8,1:3)=0;
        end
    end
end
tempImage=uint8(Image);
image(tempImage);
imwrite(tempImage,'ex_1_2_b.jpg');