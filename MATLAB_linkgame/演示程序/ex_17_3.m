clear all, close all, clc;

txt = ['����ȫ�ɿ�';'��ȫ�ɿ� '];
A1 = [1,1;0,-1];
B1 = [1;0];
M1 = ctrb(A1,B1);
n1 = rank(M1);
disp(['ϵͳ1',txt(1+(n1==2),:)]);
A2 = [1,1;2,-1];
B2 = [0;1];
M2 = ctrb(A2,B2);
n2 = rank(M2);
disp(['ϵͳ2',txt(1+(n2==2),:)]);
