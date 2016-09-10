close all;clear all;clc;
image=imread('graycapture.jpg');
% 分块
data=double(image);
[row,column]=size(data);
row_average=(sum(data,1)/row)';
row_average_dc=sum(row_average)/length(row_average);
column_average=sum(data,2)/column;
column_average_dc=sum(column_average)/length(column_average);
% 竖直方向
[tc,omgc,FTc,IFTc]=prefourier([0,length(column_average)],length(column_average),[0,0.3],1000);
C=FTc*(column_average-column_average_dc);
C_amp=abs(C);C_ang=angle(C);
column_max_omg=omgc(C_amp==max(C_amp));
Hb=floor(1/(column_max_omg/(2*pi)))-1;
Ys=round(abs(Hb/(2*pi)*(pi+C_ang(C_amp==max(C_amp)))))+5;
% 水平方向
[tr,omgr,FTr,IFTr]=prefourier([0,length(row_average)],length(row_average),[0,0.3],1000);
R=FTr*(row_average-row_average_dc);
R_amp=abs(R);R_ang=angle(R);
row_max_omg=omgr(R_amp==max(R_amp));
Wb=floor(1/(row_max_omg/(2*pi)));
Xs=round(abs(Wb/(2*pi)*(pi+R_ang(R_amp==max(R_amp)))))+12;
% 调用omg函数
load mtx.mat;
steps=omg(mtx);
number=steps(1);
steps(1)=[];
for i=1:number
    x1=steps(1);y1=steps(2);x2=steps(3);y2=steps(4);
    steps(1:4)=[];
    image(Ys+(x1-1)*Hb+1:Ys+x1*Hb,Xs+(y1-1)*Wb+1:Xs+y1*Wb)=0;
    image(Ys+(x2-1)*Hb+1:Ys+x2*Hb,Xs+(y2-1)*Wb+1:Xs+y2*Wb)=0;
end
imshow(image);
hold on;
for ii=0:12
    plot([Xs+ii*Wb Xs+ii*Wb],[1 length(column_average)],'red');
end
for ii=0:7
    plot([1 length(row_average)],[Ys+ii*Hb Ys+ii*Hb],'red');
end
steps=omg(mtx);
number=steps(1);
steps(1)=[];
for i=1:number
    x1=steps(1);y1=steps(2);x2=steps(3);y2=steps(4);
    steps(1:4)=[];
    text(Xs+(y1-0.5)*Wb,Ys+(x1-0.5)*Hb,num2str(i),'horiz','center','color','white','FontSize',20);
    text(Xs+(y2-0.5)*Wb,Ys+(x2-0.5)*Hb,num2str(i),'horiz','center','color','white','FontSize',20);
end