clear all, close all, clc;

syms n a b z;
x = a^n; %ע�ⲻ�ܳ���heaviside(n)����Ϊn=0ʱ����Ϊ1/2
X = ztrans(x);
H = 1/(1-b*z^(-1));
Y = H*X;
y1 = iztrans(Y);
y = simplify(y1)