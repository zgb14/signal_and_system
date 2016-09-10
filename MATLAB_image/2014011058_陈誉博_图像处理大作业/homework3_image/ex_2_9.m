close all;clear all;clc;
load hall.mat;
load JpegCoeff.mat;
load result.mat;
[row,column]=size(hall_gray);
% 差分
DC=result(1,:);
DCtemp=[0,DC];
DCtemp(end)=[];
DC_diff=DCtemp-DC;
DC_diff(1)=-DC_diff(1);
% disp([DC;DC_diff]);

% Huffman编码+熵编码
Category=floor(log2(abs(DC_diff)))+1;
Category(DC_diff==0)=0;
% disp([DC_diff;Category]);
% DCcode是DC输出码流，ACcode是AC输出码流
DCcode=[];ACcode=[];
for i=1:length(Category)
    Length=DCTAB(Category(i)+1,1);
    part1=DCTAB(Category(i)+1,2:Length+1);
    if DC_diff(i)>0
        part2=double(dec2bin(DC_diff(i)))-48;
    else
        if DC_diff(i)<0
            part2=double(double(dec2bin(abs(DC_diff(i))))-48==0);
        else
            part2=[];
        end
    end
    code=[part1,part2];
    DCcode=[DCcode,code];
end
EOB=[1,0,1,0];
ZRL=[ones(1,8),0,0,1];
for i=1:length(Category)
    AC=(result(2:64,i))';
    pos=find(AC~=0);
    if isempty(pos) % AC分量中没有非零值，直接编码为EOB
        ACcode=[ACcode,EOB];
    else
        pos=[0,pos];
        for j=2:length(pos)
            Run=pos(j)-pos(j-1)-1;
            part1=[];part2=[];
            for k=1:floor(Run/16)
                part1=[part1,ZRL];
            end
            if Run>15
                Run=Run-floor(Run/16)*16;
            end
            Size=floor(log2(abs(AC(pos(j)))))+1;
            [Lia,Loc]=ismember([Run,Size],ACTAB(:,1:2),'rows');
            Length=ACTAB(Loc,3);
            part1=[part1,ACTAB(Loc,4:Length+3)];
            if AC(pos(j))>0
                part2=double(dec2bin(AC(pos(j))))-48;
            else
                if AC(pos(j))<0
                    part2=double(double(dec2bin(abs(AC(pos(j)))))-48==0);
                else
                    part2=[];
                end
            end
            code=[part1,part2];
            ACcode=[ACcode,code];
        end
        ACcode=[ACcode,EOB];
    end
end
save jpegcodes.mat DCcode ACcode row column;