close all;clear all;clc;
load block_color.mat;
image=imread('colorcapture.jpg');
[row,column]=size(image);
load mtx_program.mat;
steps=omg(mtx_result);
number=steps(1);
steps(1)=[];
for i=1:number
    x1=steps(1);y1=steps(2);x2=steps(3);y2=steps(4);
    steps(1:4)=[];
    image(Ys+(x1-1)*Hb+1:Ys+x1*Hb,Xs+(y1-1)*Wb+1:Xs+y1*Wb,:)=0;
    image(Ys+(x2-1)*Hb+1:Ys+x2*Hb,Xs+(y2-1)*Wb+1:Xs+y2*Wb,:)=0;
end
imshow(image);
hold on;
for ii=0:12
    plot([Xs+ii*Wb Xs+ii*Wb],[1 row],'red');
end
for ii=0:7
    plot([1 column],[Ys+ii*Hb Ys+ii*Hb],'red');
end
steps=omg(mtx_result);
number=steps(1);
steps(1)=[];
for i=1:number
    x1=steps(1);y1=steps(2);x2=steps(3);y2=steps(4);
    steps(1:4)=[];
    text(Xs+(y1-0.5)*Wb,Ys+(x1-0.5)*Hb,num2str(i),'horiz','center','color','white','FontSize',20);
    text(Xs+(y2-0.5)*Wb,Ys+(x2-0.5)*Hb,num2str(i),'horiz','center','color','white','FontSize',20);
end