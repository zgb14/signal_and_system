close all;clear all;clc;
mtx_result=zeros(12,7);
load coff_data.mat;
i=[];
value1=0.689;
count=1;
while ~isempty(find(mtx_result==0, 1))
    if isempty(i)
        [r,c]=find(mtx_result==0);
        row=r(1);column=c(1);
        number=(column-1)*12+row;
        i=number;
    else
        temp_data=coff_data(i,:);
        [pic_st,pic_number]=find(temp_data==max(max(temp_data)));
        if max(max(temp_data))>value1
            i=[i,pic_number'];
        else
            cc=floor((i-1)/12)+1;
            rr=mod((i-1),12)+1;
            for l=1:length(rr)
                mtx_result(rr(l),cc(l))=count;
            end
            count=count+1;
            i=[];
        end
        coff_data(coff_data==max(max(temp_data)))=0;
    end
end
mtx_result=mtx_result';
load mtx.mat;
[tempr,tempc]=find((mtx-mtx_result)==0);
% test 是得到的索引矩阵与标准索引矩阵中相同元素的个数
test=length(tempr)