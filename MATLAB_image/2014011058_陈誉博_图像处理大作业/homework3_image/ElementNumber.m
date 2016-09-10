function [Element,Number]=ElementNumber(a)
% 输入必须为列向量
[row,column]=size(a);
x=sort(a);
d=diff([x;max(x)+1]);
count=diff(find([1;d]));
Element=x(find(d));
Number=count;
end