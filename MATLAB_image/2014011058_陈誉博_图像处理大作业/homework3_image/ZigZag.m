function result = ZigZag(input)
% inputÎªÊäÈëµÄ´ıÉ¨Ãè¾ØÕó
result=zeros(1,64);
maxrow=8;
maxcolumn=8;
present=input(1,1);
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
    result(i)=present;
    if ~(row==maxrow&&column==maxcolumn)
    present=input(row+addrow,column+addcolumn);
    end
    row=row+addrow;
    column=column+addcolumn;
end
result(1)=[];
end