close all;clear all;clc;
load mtx.mat;
load coff_colordata.mat coff_colordata;
i=1;
result=zeros(10,3);
while i<=10
    [Loc_row,Loc_column]=find(coff_colordata==max(max(coff_colordata)));
    row1=floor((Loc_row-1)/12)+1;column1=mod(Loc_row-1,12)+1;
    row2=floor((Loc_column-1)/12)+1;column2=mod(Loc_column-1,12)+1;
    number1=mtx(row1,column1);
    number2=mtx(row2,column2);
    if number1==number2
        coff_colordata(Loc_row,Loc_column)=0;
    else
        result(i,:)=[Loc_row,Loc_column,coff_colordata(Loc_row,Loc_column)];
        coff_colordata(Loc_row,Loc_column)=0;
        image1=imread(['ex_2_7/pic/ex_2_7_',num2str(Loc_row),'.jpg']);
        image2=imread(['ex_2_7/pic/ex_2_7_',num2str(Loc_column),'.jpg']);
        subplot(5,2,i);
        imshow([image1,image2]);
        title(['相关系数：',num2str(result(i,3))]);
        i=i+1;
    end
end