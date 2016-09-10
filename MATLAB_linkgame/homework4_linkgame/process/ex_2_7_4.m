close all;clear all;clc;
mtx_result=zeros(12,7);
load coff_colordata.mat;
load coff_data.mat;
i=1;
while ~isempty(find(mtx_result==0, 1))
    [r,c]=find(mtx_result==0);row=r(1);column=c(1);
    mtx_result(row,column)=i;
    number=(column-1)*12+row;
    temp=find(coff_colordata(number,:)>0.80);
    cc=(floor((temp-1)/12)+1)';
    rr=(mod((temp-1),12)+1)';
    for j=1:length(rr)
        if coff_data(number,temp(j))>0.65
            mtx_result(rr(j),cc(j))=i;
        end
    end
    i=i+1;
end
mtx_result=mtx_result';
load mtx.mat;
[tempr,tempc]=find((mtx-mtx_result)==0);
% test 是得到的索引矩阵与标准索引矩阵中相同元素的个数
test=length(tempr)