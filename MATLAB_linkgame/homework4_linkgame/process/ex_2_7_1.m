close all;clear all;clc;
image=imread('colorcapture.jpg');
% R 通道分块
data_r=double(image(:,:,1));
[row,column]=size(data_r);
row_average=(sum(data_r,1)/row)';
row_average_dc=sum(row_average)/length(row_average);
column_average=sum(data_r,2)/column;
column_average_dc=sum(column_average)/length(column_average);
% R 通道竖直方向
[~,omgc,FTc,IFTc]=prefourier([0,length(column_average)],length(column_average),[0,0.3],1000);
C=FTc*(column_average-column_average_dc);
C_amp=abs(C);C_ang=angle(C);
column_max_omg=omgc(C_amp==max(C_amp));
Hb_r=floor(1/(column_max_omg/(2*pi)))-2;
Ys_r=round(abs(Hb_r/(2*pi)*(pi+C_ang(C_amp==max(C_amp)))))+2;
% R 通道水平方向
[~,omgr,FTr,IFTr]=prefourier([0,length(row_average)],length(row_average),[0,0.3],1000);
R=FTr*(row_average-row_average_dc);
R_amp=abs(R);R_ang=angle(R);
row_max_omg=omgr(R_amp==max(R_amp));
Wb_r=floor(1/(row_max_omg/(2*pi)))-1;
Xs_r=round(abs(Wb_r/(2*pi)*(pi+R_ang(R_amp==max(R_amp)))))+16;
% G 通道分块
data_g=double(image(:,:,2));
[row,column]=size(data_g);
row_average=(sum(data_g,1)/row)';
row_average_dc=sum(row_average)/length(row_average);
column_average=sum(data_g,2)/column;
column_average_dc=sum(column_average)/length(column_average);
% G 通道竖直方向
[~,omgc,FTc,IFTc]=prefourier([0,length(column_average)],length(column_average),[0,0.3],1000);
C=FTc*(column_average-column_average_dc);
C_amp=abs(C);C_ang=angle(C);
column_max_omg=omgc(C_amp==max(C_amp));
Hb_g=floor(1/(column_max_omg/(2*pi)));
Ys_g=round(abs(Hb_g/(2*pi)*(pi+C_ang(C_amp==max(C_amp)))))+5;
% G 通道水平方向
[~,omgr,FTr,IFTr]=prefourier([0,length(row_average)],length(row_average),[0,0.3],1000);
R=FTr*(row_average-row_average_dc);
R_amp=abs(R);R_ang=angle(R);
row_max_omg=omgr(R_amp==max(R_amp));
Wb_g=floor(1/(row_max_omg/(2*pi)))-1;
Xs_g=round(abs(Wb_g/(2*pi)*(pi+R_ang(R_amp==max(R_amp)))))+17;
% B 通道分块
data_b=double(image(:,:,3));
[row,column]=size(data_b);
row_average=(sum(data_b,1)/row)';
row_average_dc=sum(row_average)/length(row_average);
column_average=sum(data_b,2)/column;
column_average_dc=sum(column_average)/length(column_average);
% B 通道竖直方向
[~,omgc,FTc,IFTc]=prefourier([0,length(column_average)],length(column_average),[0,0.3],1000);
C=FTc*(column_average-column_average_dc);
C_amp=abs(C);C_ang=angle(C);
column_max_omg=omgc(C_amp==max(C_amp));
Hb_b=floor(1/(column_max_omg/(2*pi)));
Ys_b=round(abs(Hb_b/(2*pi)*(pi+C_ang(C_amp==max(C_amp)))))+6;
% B 通道水平方向
[~,omgr,FTr,IFTr]=prefourier([0,length(row_average)],length(row_average),[0,0.3],1000);
R=FTr*(row_average-row_average_dc);
R_amp=abs(R);R_ang=angle(R);
row_max_omg=omgr(R_amp==max(R_amp));
Wb_b=floor(1/(row_max_omg/(2*pi)));
Xs_b=round(abs(Wb_b/(2*pi)*(pi+R_ang(R_amp==max(R_amp)))))+17;
% 取平均得到最终的分块参数
Hb=round((Hb_r+Hb_b+Hb_g)/3);
Ys=round((Ys_r+Ys_b+Ys_g)/3);
Wb=round((Wb_r+Wb_b+Wb_g)/3);
Xs=round((Xs_r+Xs_g+Xs_b)/3)+2;
for i=1:7
    for j=1:12
        number=(i-1)*12+j;
        subplot(7,12,number);
        picture=image(Ys+(i-1)*Hb+1:Ys+i*Hb,Xs+(j-1)*Wb+1:Xs+j*Wb,:);
        imshow(picture);
        imwrite(picture,['ex_2_7/pic/ex_2_7_',num2str(number),'.jpg']);
        picture_hp=zeros(size(picture));
        %高通滤波
        for channel=1:3
            PIC=fft2(double(picture(:,:,channel)));
            PIC_shift=fftshift(PIC);
            [r,c]=size(PIC_shift);
            frequency=1;
            for ii=1:r
                for jj=1:c
                    dis=sqrt((ii-r/2)^2+(jj-c/2)^2);
                    if dis<=frequency
                        PIC_shift(ii,jj)=0;
                    end
                end
            end
            PIC2=ifftshift(PIC_shift);
            picture_hp(:,:,channel)=uint8(real(ifft2(PIC2)));
        end
        imwrite(picture_hp,['ex_2_7/pic_hp/ex_2_7_',num2str(number),'.jpg']);
    end
end
save block_color.mat Hb Ys Wb Xs;
