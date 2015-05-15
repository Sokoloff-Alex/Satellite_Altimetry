% correction

SumOfCorrections = otide + etide + invb + wtrop + dtrop + ionos + ptide + emb;
SSH = hsat - ralt - SumOfCorrections;

STD_sorted = sort(stdalt,'descend');

%
figure(2)
hold on
plot(stdalt,'b')
plot(STD_sorted,'r')
% plot(0:1442,0.2,'-g')
legend('stdalt','stdalt sorted','treshold')
ylabel('[m]')
xlimit = [0,1442];
hold off




%%

figure(1)
subplot(2,2,1)
hold on
plot(SSH,'g')
plot(mssh,'b')
plot(geoh,'r')
ylabel('[m]')
hold off
legend('SSH','mssh','geoh')
subplot(2,2,2)
hold on
plot(stdalt,'g')
plot(swh,'b')
legend('stdalt','swh')
ylabel('[m]')
hold off
subplot(2,2,3)
hold on
plot(SSH - mssh,'b')
plot(SSH - geoh,'g')
ylabel('[m]')
hold off
legend('SSH - mssh','SSH - geoh')
subplot(2,2,4)
hold on
plot(otide)
plot(etide)
plot(invb)
plot(wtrop)
plot(dtrop,'g')
plot(ionos,'m')
plot(ptide)
plot(SumOfCorrections,'r')
legend('otide','etide','invb','wtrop','dtrop','ionos','ptide','SumOfCorrections')
ylabel('[m]')
hold off