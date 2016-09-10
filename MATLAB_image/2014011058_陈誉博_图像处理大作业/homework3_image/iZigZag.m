function result=iZigZag(inputDC,inputAC)
% inputDC是输入的直流分量，inputAC是输入的待拼接交流分量
% inputDC是double，inputAC必须是行向量
maxrow=8;
maxcolumn=8;
result=zeros(maxrow,maxcolumn);
tempinput=[inputDC,inputAC];
count=0;
addrow=0;
addcolumn=0;
flag=0;
row=1;column=1;
for i=1:64
    if (row==1||row==maxrow)&&(flag==0)
        addrow=0;
        addcolumn=1;
        count=count+1;
        flag=1;
    else
        if (column==1||column==maxcolumn)&&(flag==0)
            addrow=1;
            addcolumn=0;
            count=count+1;
            flag=1;
        else
            if mod(count,2)==1
                addrow=1;
                addcolumn=-1;
                flag=0;
            else
                addrow=-1;
                addcolumn=1;
                flag=0;
            end
        end
    end
    result(row,column)=tempinput(i);
    row=row+addrow;
    column=column+addcolumn;
end
end