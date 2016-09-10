function C=my_dct2(P)
%row must equals column
[row,column]=size(P);
N=row;
D=zeros(row,column);
D(1,:)=sqrt(1/2);
for i=2:N
    for j=1:N
      D(i,j)=cos(pi*(i-1)*(2*j-1)/(2*N));  
    end
end
D=D*sqrt(2/N);
C=D*P*D';
end