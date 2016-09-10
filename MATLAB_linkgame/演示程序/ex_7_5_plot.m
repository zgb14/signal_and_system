figure;
box on, hold on;
subplot(2,1,1), hold on, box on;
set(gca,'FontSize',16);
stem([0:length(h)-1]',h,'k');
ylabel('h(n)');
subplot(2,1,2), hold on, box on;
stem([0:length(h0)-1]',h0,'k');
set(gca,'FontSize',16);
xlabel('n');
ylabel('h_{0}(n)');