function bool = detect(mtx, x1, y1, x2, y2)
% ========================== ����˵�� ==========================

% ��������У�mtxΪͼ���ľ������������ĸ�ʽ��
% [ 1 2 3;
%   0 2 1;
%   3 0 0 ]
% ��ͬ�����ִ�����ͬ��ͼ����0����˴�û�п顣
% ������[m, n] = size(mtx)��ȡ������������
% (x1, y1)�루x2, y2��Ϊ���жϵ�������±꣬���ж�mtx(x1, y1)��mtx(x2, y2)
% �Ƿ������ȥ��

% ע��mtx��������Ϸ�����ͼ����λ�ö�Ӧ��ϵ���±�(x1, y1)��������������
% ������������½�Ϊԭ�㽨������ϵ��x�᷽���x1����y�᷽���y1��

% �������bool = 1��ʾ������ȥ��bool = 0��ʾ������ȥ��

%% �����������Ĵ���O(��_��)O

[m, n] = size(mtx);

bool = 0;

if (x1>m||x2>m||y1>n||y2>n)||(mtx(x1,y1)~=mtx(x2,y2))||(mtx(x1,y1)==0||mtx(x2,y2)==0)
    bool=0;
else
    %% ���������鴦��ͬһֱ����
    if (x1==x2)||(y1==y2)
        if x1==x2 %ˮƽֱ��
            if y1<y2
                temp=mtx(x1,y1+1:y2-1);
            else
                temp=mtx(x1,y2+1:y1-1);
            end
            if isempty(temp)||isequal(temp,zeros(1,length(temp)))
                bool=1;
            else
                if (x1==1||x1==m)||(isequal(mtx(1:x1-1,y1),zeros(x1-1,1))&&isequal(mtx(1:x1-1,y2),zeros(x1-1,1)))||(isequal(mtx(x1+1:m,y1),zeros(m-x1,1))&&isequal(mtx(x1+1:m,y2),zeros(m-x1,1)))
                    bool=1;
                else
                    [Lia,Loc]=ismember(zeros(1,max(y1,y2)-min(y1,y2)+1),mtx(:,min(y1,y2):max(y1,y2)),'rows');
                    Loc=find(sum(abs(mtx(:,min(y1,y2):max(y1,y2))),2)==0);
                    if Lia==1
                        for i=1:length(Loc)
                            if Loc(i)<x1
                                if isequal(mtx(Loc(i):x1-1,y1),zeros(x1-Loc(i),1))&&isequal(mtx(Loc(i):x1-1,y2),zeros(x1-Loc(i),1))
                                    bool=1;
                                    break;
                                end
                            else
                                if isequal(mtx(x1+1:Loc(i),y1),zeros(1,Loc(i)-x1))&&isequal(mtx(x1+1:Loc(i),y2),zeros(1,Loc(i)-x1))
                                    bool=1;
                                    break;
                                end
                            end
                        end
                    end
                end
            end
        else %��ֱֱ��
            if x1<x2
                temp=mtx(x1+1:x2-1,y1);
            else
                temp=mtx(x2+1:x1-1,y1);
            end
            if isempty(temp)||isequal(temp,zeros(length(temp),1))
                bool=1;
            else
                if (y1==1||y1==n)||(isequal(mtx(x1,1:y1-1),zeros(1,y1-1))&&isequal(mtx(x2,1:y1-1),zeros(1,y1-1)))||(isequal(mtx(x1,y1+1:n),zeros(1,n-y1))&&isequal(mtx(x2,y1+1:n),zeros(1,n-y1)))
                    bool=1;
                else
                    [Lia,Loc]=ismember(zeros(1,max(x1,x2)-min(x1,x2)+1),(mtx(min(x1,x2):max(x1,x2),:))','rows');
                    Loc=find(sum(abs((mtx(min(x1,x2):max(x1,x2),:))'),2)==0);
                    if Lia==1
                        for i=1:length(Loc)
                            if Loc(i)<y1
                                if isequal(mtx(x1,Loc(i):y1-1),zeros(1,y1-Loc(i)))&&isequal(mtx(x2,Loc(i):y1-1),zeros(1,y1-Loc(i)))
                                    bool=1;
                                    break;
                                end
                            else
                                if isequal(mtx(x1,y1+1:Loc(i)),zeros(1,Loc(i)-y1))&&isequal(mtx(x2,y1+1:Loc(i)),zeros(1,Loc(i)-y1))
                                    bool=1;
                                    break;
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        %% ����ͬһֱ���� ��һ����
        if y1<y2
            temp_row1=mtx(x1,y1+1:y2);
            temp_row2=mtx(x2,y1:y2-1);
        else
            temp_row1=mtx(x1,y2:y1-1);
            temp_row2=mtx(x2,y2+1:y1);
        end
        if x1<x2
            temp_column2=mtx(x1+1:x2,y1);
            temp_column1=mtx(x1:x2-1,y2);
        else
            temp_column2=mtx(x2:x1-1,y1);
            temp_column1=mtx(x2+1:x1,y2);
        end
        if (isempty(find(temp_row1,1))&&isempty(find(temp_column1,1)))||(isempty(find(temp_row2,1))&&isempty(find(temp_column2,1)))
            bool=1;
        else
            %%  ����ͬһֱ���� ������
            if (isequal(mtx(1:x1-1,y1),zeros(x1-1,1))&&isequal(mtx(1:x2-1,y2),zeros(x2-1,1)))||(isequal(mtx(x1+1:m,y1),zeros(m-x1,1))&&isequal(mtx(x2+1:m,y2),zeros(m-x2,1)))
                bool=1;
            else
                if (isequal(mtx(x1,1:y1-1),zeros(1,y1-1))&&isequal(mtx(x2,1:y2-1),zeros(1,y2-1)))||(isequal(mtx(x1,y1+1:n),zeros(1,n-y1))&&isequal(mtx(x2,y2+1:n),zeros(1,n-y2)))
                    bool=1;
                else
                    [LiaH,LocH]=ismember(zeros(1,max(y1,y2)-min(y1,y2)+1),mtx(:,min(y1,y2):max(y1,y2)),'rows');
                    LocH=find(sum(abs(mtx(:,min(y1,y2):max(y1,y2))),2)==0);
                    if LiaH==1
                        for i=1:length(LocH)
                            if LocH(i)<min(x1,x2)
                                if isequal(mtx(LocH(i):x1-1,y1),zeros(x1-LocH(i),1))&&isequal(mtx(LocH(i):x2-1,y2),zeros(x2-LocH(i),1))
                                    bool=1;
                                    break;
                                end
                            else
                                if LocH(i)>max(x1,x2)
                                    if isequal(mtx(x1+1:LocH(i),y1),zeros(LocH(i)-x1,1))&&isequal(mtx(x2+1:LocH(i),y2),zeros(LocH(i)-x2,1))
                                        bool=1;
                                        break;
                                    end
                                else
                                    x=[x1,x2];y=[y1,y2];
                                    if isequal(mtx(min(x)+1:LocH(i),y(x==min(x))),zeros(LocH(i)-min(x),1))&&isequal(mtx(LocH(i):max(x)-1,y(x==max(x))),zeros(max(x)-LocH(i),1))
                                        bool=1;
                                        break;
                                    end
                                end
                            end
                        end
                    end
                    [LiaV,LocV]=ismember(zeros(1,max(x1,x2)-min(x1,x2)+1),(mtx(min(x1,x2):max(x1,x2),:))','rows');
                    LocV=find(sum(abs((mtx(min(x1,x2):max(x1,x2),:))'),2)==0);
                    if LiaV==1
                        for i=1:length(LocV)
                            if LocV(i)<min(y1,y2)
                                if isequal(mtx(x1,LocV(i):y1-1),zeros(1,y1-LocV(i)))&&isequal(mtx(x2,LocV(i):y2-1),zeros(1,y2-LocV(i)))
                                    bool=1;
                                    break;
                                end
                            else
                                if LocV(i)>max(y1,y2)
                                    if isequal(mtx(x1,y1+1:LocV(i)),zeros(1,LocV(i)-y1))&&isequal(mtx(x2,y2+1:LocV(i)),zeros(1,LocV(i)-y2))
                                        bool=1;break;
                                    end
                                else
                                    x=[x1,x2];y=[y1,y2];
                                    if isequal(mtx(x(y==min(y)),min(y)+1:LocV(i)),zeros(1,LocV(i)-min(y)))&&isequal(mtx(x(y==max(y)),LocV(i):max(y)-1),zeros(1,max(y)-LocV(i)))
                                        bool=1;break;
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end
end

