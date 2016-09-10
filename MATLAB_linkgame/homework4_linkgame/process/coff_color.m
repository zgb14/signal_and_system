close all;clear all;clc;
coff_colordata=zeros(84,84);
for i=1:84
    for j=(i+1):84
        data1=double(imread(['ex_2_7/pic_hp/ex_2_7_',num2str(i),'.jpg']));
        data1_r=data1(:,:,1);data1_g=data1(:,:,2);data1_b=data1(:,:,3);
        data2=double(imread(['ex_2_7/pic_hp/ex_2_7_',num2str(j),'.jpg']));
        data2_r=data2(:,:,1);data2_g=data2(:,:,2);data2_b=data2(:,:,3);
        R1=max(max(xcorr2(data1_r,data1_r)));
        R2=max(max(xcorr2(data2_r,data2_r)));
        R12=max(max(xcorr2(data1_r,data2_r)));
        coff_R=R12/sqrt(R1*R2);
        G1=max(max(xcorr2(data1_g,data1_g)));
        G2=max(max(xcorr2(data2_g,data2_g)));
        G12=max(max(xcorr2(data1_g,data2_g)));
        coff_G=G12/sqrt(G1*G2);
        B1=max(max(xcorr2(data1_b,data1_b)));
        B2=max(max(xcorr2(data2_b,data2_b)));
        B12=max(max(xcorr2(data1_b,data2_b)));
        coff_B=B12/sqrt(B1*B2);
        coff_colordata(i,j)=(coff_R+coff_G+coff_B)/3;
    end
end
save coff_colordata.mat coff_colordata;