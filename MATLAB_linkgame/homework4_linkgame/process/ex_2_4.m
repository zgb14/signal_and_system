close all;clear all;clc;
mtx=[1,2,1,3,4,5,6,7,8,9,9,10;
    11,3,10,12,10,13,8,14,9,15,16,8;
    17,18,9,15,12,11,6,12,2,6,17,11;
    12,18,8,12,2,8,6,3,6,11,12,17;
    16,2,14,4,18,9,18,9,13,7,12,3;
    17,8,19,17,1,19,17,7,4,13,7,8;
    13,8,6,9,4,5,10,1,13,9,12,13];
save mtx.mat mtx;
load coff_data.mat coff_data;
i=1;
result=zeros(10,3);
while i<=10
    [Loc_row,Loc_column]=find(coff_data==max(max(coff_data)));
    row1=floor((Loc_row-1)/12)+1;column1=mod(Loc_row-1,12)+1;
    row2=floor((Loc_column-1)/12)+1;column2=mod(Loc_column-1,12)+1;
    number1=mtx(row1,column1);
    number2=mtx(row2,column2);
    if number1==number2
        coff_data(Loc_row,Loc_column)=0;
    else
        result(i,:)=[Loc_row,Loc_column,coff_data(Loc_row,Loc_column)];
        coff_data(Loc_row,Loc_column)=0;
        image1=imread(['ex_2_2_pic/ex_2_2_',num2str(Loc_row),'.jpg']);
        image2=imread(['ex_2_2_pic/ex_2_2_',num2str(Loc_column),'.jpg']);
        subplot(5,2,i);
        imshow([image1,image2]);
        title(['相关系数：',num2str(result(i,3))]);
        i=i+1;
    end
end