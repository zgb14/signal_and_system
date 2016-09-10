close all;clear all;clc;
image=imread('graygroundtruth.jpg');
Fs=1;
data=double(image);
[row,column]=size(data);
row_average=(sum(data,1)/row)';
row_average_dc=sum(row_average)/length(row_average);
column_average=sum(data,2)/column;
column_average_dc=sum(column_average)/length(column_average);

[tc,omgc,FTc,IFTc]=prefourier([0,length(column_average)],length(column_average),[0,0.3],1000);
figure;
C=FTc*(column_average-column_average_dc);
C_amp=abs(C);C_ang=angle(C);
column_max_omg=omgc(C_amp==max(C_amp));
Hb=floor(1/(column_max_omg/(2*pi)))-2;
Ys=round(abs(Hb/(2*pi)*(pi+C_ang(C_amp==max(C_amp)))))+10;
subplot(3,1,1);plot(tc,column_average-column_average_dc);
hold on;plot([Ys Ys],[0 100],'red');
subplot(3,1,2);plot(omgc,C_amp,'r');
subplot(3,1,3);plot(omgc,C_ang,'g');

[tr,omgr,FTr,IFTr]=prefourier([0,length(row_average)],length(row_average),[0,0.3],1000);
figure;
R=FTr*(row_average-row_average_dc);
R_amp=abs(R);R_ang=angle(R);
row_max_omg=omgr(R_amp==max(R_amp));
Wb=floor(1/(row_max_omg/(2*pi)))-1;
Xs=round(abs(Wb/(2*pi)*(pi+R_ang(R_amp==max(R_amp)))));
subplot(3,1,1);plot(tr,row_average-row_average_dc);
hold on;plot([Xs Xs],[0 100],'red');
subplot(3,1,2);plot(omgr,R_amp,'r');
subplot(3,1,3);plot(omgr,R_ang,'g');

figure;
imshow(image);
hold on;
% for i=0:12
%     plot([Xs+i*Wb Xs+i*Wb],[1 length(column_average)],'red');
% end
% for i=0:7
%     plot([1 length(row_average)],[Ys+i*Hb Ys+i*Hb],'red');
% end
for i=1:7
    for j=1:12
        number=(i-1)*12+j;
        subplot(7,12,number);
        picture=image(Ys+(i-1)*Hb+1:Ys+i*Hb,Xs+(j-1)*Wb+1:Xs+j*Wb);
        imshow(picture);
        imwrite(picture,['ex_2_1_pic/ex_2_1_',num2str(number),'.jpg']);
    end
end