clear all, close all, clc;

txt = ['����ȫ�ɹ�';'��ȫ�ɹ� '];
A = [1,1;-2,-1];
C = [1,0];
N = obsv(A,C);
n = rank(N);
disp(['ϵͳ1',txt(1+(n==2),:)]);

