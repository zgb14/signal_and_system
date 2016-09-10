clear all, close all, clc;

omega0 = 1;
b = [1,0];
figure(1);
for theta = pi:-pi/50:pi/2
    alpha = omega0 * -cos(theta);
    a = [1,2*alpha,omega0^2];
    subplot(2,2,1);
    pzmap(b,a);
    set(gca,'XLim',[-1.5,0.5],'YLim',[-1.5,1.5]);
%     [h,x,t] = impulse(b,a,[0:0.1:30]);
    sys=tf(b,a);
    subplot(2,2,3);
    impulse(sys);
    set(gca,'XLim',[0,30],'YLim',[-2,2]);
    [H,w] = freqs(b,a,[0.01:0.01:100]);
    subplot(2,2,2);
    plot(w,abs(H));
    set(gca,'XLim',[0.01,100],'YLim',[0.01,10],'YScale','log','XScale','log');
    grid on;
    subplot(2,2,4);
    plot(w,angle(H));
    set(gca,'XLim',[0.01,100],'YLim',[-pi,pi],'XScale','log');
    grid on;
    pause(0.01);
end