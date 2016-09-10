close all;clear all;clc;
load hall.mat;
Image=double(hall_color);
[height,width,channel]=size(Image);
R=min([height,width])/2;
center=[height,width]/2;
temp=zeros(height,width,channel);
D1=0;
for i=2*pi/100000:2*pi/100000:2*pi
    if ceil(R*cos(i))+center(1)==0
        D1=1;
    else 
        D1=ceil(R*cos(i))+center(1);
    end
    Image(D1,ceil(R*sin(i))+center(2),1)=255;
    Image(D1,ceil(R*sin(i))+center(2),2)=0;
    Image(D1,ceil(R*sin(i))+center(2),3)=0;
end
tempImage=uint8(Image);
image(tempImage);
imwrite(tempImage,'ex_1_2_a.jpg');