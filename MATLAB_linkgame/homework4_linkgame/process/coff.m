close all;clear all;clc;
coff_data=zeros(84,84);
for i=1:84
    for j=(i+1):84
        data1=double(imread(['ex_2_2_pic_hp/ex_2_2_',num2str(i),'.jpg']));
        data2=double(imread(['ex_2_2_pic_hp/ex_2_2_',num2str(j),'.jpg']));
        E1=max(max(xcorr2(data1,data1)));
        E2=max(max(xcorr2(data2,data2)));
        E12=max(max(xcorr2(data1,data2)));
        coff_data(i,j)=E12/sqrt(E1*E2);
    end
end
save coff_data.mat coff_data;
