
clear all
load displaySequence.mat


sig=testData{1,1};
label=testData{1,2};
% sig=sig(1:1000)
% label=label(1:1000)


X = sig
classes = categories(label)

naSig=nan(size(sig));
PSig=naSig;
QRSSig=naSig;
TSig=naSig;

for i=1:length(sig)
  if label(i)=='n/a' && i < length(sig)
    naSig([i,i+1])=[X(i), X(i+1)];
  elseif label(i)=='P' && i < length(sig)
    PSig([i,i+1])=[X(i), X(i+1)];
  elseif label(i)=='QRS' && i < length(sig)
    QRSSig([i,i+1])=[X(i), X(i+1)];
  elseif label(i)=='T' &&  i < length(sig)
    TSig([i,i+1])=[X(i), X(i+1)];
  end
end

Sig1=naSig;
Sig2=PSig;
Sig3=QRSSig;
Sig4=TSig;


figure

lineWidth=2
% plot(sig,'g','LineWidth',lineWidth)
plot(QRSSig,'g','LineWidth',lineWidth)
hold on
plot(naSig,'LineWidth',lineWidth,'Color',[1 0.76 0])

plot(PSig,'r','LineWidth',lineWidth)
plot(QRSSig,'g','LineWidth',lineWidth)
plot(TSig,'b','LineWidth',lineWidth)
hold off


Color1=[[ones(16,1);zeros(32,1);ones(16,1)],[zeros(16,1);ones(16,1);zeros(16,1);ones(16,1)*0.76],[zeros(32,1);ones(16,1);zeros(16,1)]];
colormap(Color1)
c=colorbar('Ticks',[0.125,0.375,0.625,0.875],...
         'TickLabels',{'P','QRS','T','N/A'},"Direction","reverse")




