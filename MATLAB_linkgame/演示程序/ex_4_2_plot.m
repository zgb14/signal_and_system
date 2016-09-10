figure;
subplot(1,2,1), hold on, box on;
plot(t,f,'k-');
plot(t,real(fs),'k-.');
set(gca,'YLim',[-.5 1.5],'FontSize',16);
xlabel('t');
ylabel('f(t)');
legend('f(t)','f_s(t)');
subplot(1,2,2), hold on, box on;
plot(omg,real(F),'k-');
set(gca,'XLim',[-8*pi,8*pi],'YLim',[-0.5 1.5],'FontSize',16);
xlabel('\omega');
ylabel('F(\omega)');