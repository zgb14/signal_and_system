close all;clear all;clc;
L2=5;
I=31;
u=zeros(2^(3*L2),I);
% 每个列向量是一张图片的u
for i=1:I
    if i<10
        name=char(i+48);
    else
        name=[char(floor(i/10)+48),char(mod(i,10)+48)];
    end
    image_rgb=imread(['Faces/',name,'.bmp']);
    [row,column,channel]=size(image_rgb);
    image_convert=floor(double(image_rgb)/(2^(8-L2)));
    image_num=image_convert(:,:,1)*2^(2*L2)+image_convert(:,:,2)*2^(L2)+image_convert(:,:,3);
    for j=1:2^(3*L2)
        u(j,i)=length(find(image_num==j-1));
    end
    u(:,i)=u(:,i)/(row*column);
end
v=zeros(2^(3*L2),1);
for i=1:2^(3*L2);
    v(i)=sum(u(i,:))/I;
end
save train.mat v L2;
