function [w,tw] = conv1(u,tu,v,tv)
% �������
% u��v��ʾ�������У�tu��tv�ֱ��ʾ���ǵĳ���ʱ��
% ����ֵ
% w��tw�ֱ��ʾ�������������ʱ��

T = tu(2)-tu(1);
w = T*conv(double(u),double(v));
tw = tu(1)+tv(1)+T*[0:length(u)+length(v)-2]';
