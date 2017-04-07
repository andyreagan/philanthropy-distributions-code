%% uses ../data/UVM_accumulation.mat
clear all
figure('visible','off');
set(gcf,'color','none');
tmpfigh = gcf;
clf;
figshape(500,500);

% do you wnt more or less pnts in log space
plotlogspace = 1;

%% automatically create postscript whenever
%% figure is drawn
tmpfilename = 'UVM_accumulation_combined';

tmpfilenoname = sprintf('%s_noname',tmpfilename);

%% global switches

set(gcf,'Color','none');
set(gcf,'InvertHardCopy', 'off');

set(gcf,'DefaultAxesFontname','helvetica');
set(gcf,'DefaultLineColor','r');
set(gcf,'DefaultAxesColor','none');
set(gcf,'DefaultLineMarkerSize',4.3);
set(gcf,'DefaultLineMarkerEdgeColor','k'); % [0 128/255 0]);
set(gcf,'DefaultLineMarkerFaceColor','g');
set(gcf,'DefaultAxesLineWidth',0.5);
set(gcf,'PaperPositionMode','auto');

tmpsym = {'o','s','v','o','s','v'};
tmpcol = {[0 128/255 0],'b','r','k','c','m'};

positions(1).box = [.1 .1 .35 .35];
positions(2).box = [.55 .1 .35 .35];% [ x y w h
axesnum = 1;
tmpaxes(axesnum) = axes('position',positions(axesnum).box);

%% main data goes here
load ../../data/UVM_accum_data

dates=UVM_accum_data(1).data;
donations=UVM_accum_data(2).data;
total_donations=UVM_accum_data(3).data;


months=[31,28,31,30,31,30,31,31,30,31,30,31];
months_cum=months;
months_cum(1)=1;
for i=2:12
  months_cum(i)=sum(months(1:i-1))+1;
end

big=max(total_donations);
small=min(total_donations);
% lines for the linear thing
%% for i=1:12
%%   line([months_cum(i),months_cum(i)],[small,big]);%,'r-');%,'LineWidth',.5);
%% end
% lines for the rank plot
for i=1:12
  months_cum_rank(i)=find(dates-months_cum(i)==0,1);
end

for i=2:12
  
  % don't plot the whole december line
  if i==12
      X = [4.5e6 2.4e7];
  else
      X = [1 2.4e7];
  end
  
  plot([months_cum_rank(i) months_cum_rank(i)],X,'LineWidth',.3,'Color',0.7*[0 0 1],'LineStyle','--'); %,'r');%,'LineWidth',.5);
  hold on;
end

% plot this linearly
% plot(dates,total_donations);

% plot it by rank of gift
if plotlogspace
    pts2plot=1:250:length(total_donations); 
else
    pts2plot=1:length(total_donations);
end
plot(1:length(total_donations),total_donations,'Color',0.7*[1 1 1]);
plot(pts2plot,total_donations(pts2plot),'Marker',tmpsym{1},'MarkerFaceColor',tmpcol{1},'MarkerEdgeColor',tmpcol{1},'LineStyle','none');




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot the extension lines
xmin = 2200;
plot(xmin+[0 5500],total_donations(xmin)+[0 2200000],'Color',tmpcol{1},'LineStyle','--','LineWidth',1.5)
xmin = 15000;
plot(xmin+[0 5500],total_donations(xmin)+[0 2200000]-1000000,'Color',tmpcol{1},'LineStyle','--','LineWidth',1.5)
xmin=26500;
plot(xmin+[0 5500],total_donations(xmin)+[0 2200000]-300000,'Color',tmpcol{1},'LineStyle','--','LineWidth',1.5)


set(gca,'fontsize',16);
set(gca,'color','none');

%% for use with layered plots
%% set(gca,'box','off')

%% adjust limits
%% tmpv = axis;
%% axis([]);
ylim([0,2.4e7]);
xlim([0,length(total_donations)]);

%% change axis line width (default is 0.5)
%% set(tmpaxes(axesnum),'linewidth',2)

%% fix up tickmarks
set(gca,'xtick',months_cum_rank)
month_names={'J','F','M','A','M','J','J','A','S','O','N','D'};
set(gca,'xticklabel',month_names,'fontsize',8)

set(gca,'ytick',1e6:2e6:2.4e7);
for i=1:12
  ylabels{i}=num2str(2*i);
end
set(gca,'yticklabel',ylabels,'fontsize',8);

%% the following will usually not be printed 
%% in good copy for papers
%% (except for legend without labels)

%% remove a plot from the legend
%% set(get(get(tmph,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

%% legend
%% tmplh = legend('stuff',...);
%% tmplh = legend('','','');
%% set(tmplh,'position',get(tmplh,'position')-[x y 0 0])
%% change font
%% tmplh = findobj(tmplh,'type','text');
%% set(tmplh,'FontSize',18);
%% remove box:
%% legend boxoff

%% use latex interpreter for text, sans serif

tmpxlab=xlabel('Time','fontsize',10,'fontname','helvetica','interpreter','latex','HorizontalAlignment','center');
tmpylab=ylabel('Total Donations, in millions','fontsize',10,'fontname','helvetica','interpreter','latex'); %,'VerticalAlignment','middle');

set(tmpxlab,'position',get(tmpxlab,'position') - [0 100 0]);
%set(tmpylab,'position',get(tmpylab,'position') - [1001 100100 10010]);
set(tmpylab,'position',get(tmpylab,'position') - [1000 2000000 0]);

addlabel3(' A ',.82,.11,13);


axesnum = 2;
tmpaxes(axesnum) = axes('position',positions(axesnum).box);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% main data goes here

% legend is going to need the date ranges
times = {'Jan 4','First week','First month','First 3 mon','First 6 mon','Whole year'};



% one day (jan 4)

date_range = find(UVM_accum_data(1).data == 4);
donations = UVM_accum_data(2).data(date_range(1):date_range(end));
N = length(donations);
donations = sort(donations,'descend');

i=1;
if plotlogspace
    pts2plot=floor(logspace(0,log10(N),50)); 
else
    pts2plot=1:N;
end
line = plot(log10(1:N),log10(donations),'Color',0.7*[1 1 1]);
hold on;
tmph(i) = plot(log10(pts2plot),log10(donations(pts2plot)),'Marker',tmpsym{i},'MarkerFaceColor',tmpcol{i},'LineStyle','none'); %,'Color',[0.1328, 0.5430, 0.1328],'LineStyle','.');

% first week

date_range = find(UVM_accum_data(1).data == 7);
donations = UVM_accum_data(2).data(1:date_range(end));
N = length(donations);
donations = sort(donations,'descend');

i=2;
if plotlogspace
    pts2plot=floor(logspace(0,log10(N),75)); 
else
    pts2plot=1:N;
end
line = plot(log10(1:N),log10(donations),'Color',0.7*[1 1 1]);
tmph(i) = plot(log10(pts2plot),log10(donations(pts2plot)),'Marker',tmpsym{i},'MarkerFaceColor',tmpcol{i},'LineStyle','none'); %,'LineStyle','.');

% first month, 31 days in January

date_range = find(UVM_accum_data(1).data == 31);
donations = UVM_accum_data(2).data(1:date_range(end));
N = length(donations);
donations = sort(donations,'descend');

i=3;
if plotlogspace
    pts2plot=floor(logspace(0,log10(N),100)); 
else
    pts2plot=1:N;
end
line = plot(log10(1:N),log10(donations),'Color',0.7*[1 1 1]);
tmph(i) = plot(log10(pts2plot),log10(donations(pts2plot)),'Marker',tmpsym{i},'MarkerFaceColor',tmpcol{i},'LineStyle','none'); % ,'Color','r','LineStyle','.');

% three months, first 90 days actually

date_range = find(UVM_accum_data(1).data == 90);
donations = UVM_accum_data(2).data(1:date_range(end));
N = length(donations);
donations = sort(donations,'descend');

i=4;
if plotlogspace
    pts2plot=floor(logspace(0,log10(N),100)); 
else
    pts2plot=1:N;
end
line = plot(log10(1:N),log10(donations),'Color',0.7*[1 1 1]);
tmph(i) = plot(log10(pts2plot),log10(donations(pts2plot)),'Marker',tmpsym{i},'MarkerFaceColor',tmpcol{i},'LineStyle','none');%,'Color','c','LineStyle','.');

% 6 months, 181 days in

date_range = find(UVM_accum_data(1).data == 181);
donations = UVM_accum_data(2).data(1:date_range(end));
N = length(donations);
donations = sort(donations,'descend');

i=5;
if plotlogspace
    pts2plot=floor(logspace(0,log10(N),100)); 
else
    pts2plot=1:N;
end
line = plot(log10(1:N),log10(donations),'Color',0.7*[1 1 1]);
tmph(i) = plot(log10(pts2plot),log10(donations(pts2plot)),'Marker',tmpsym{i},'MarkerFaceColor',tmpcol{i},'LineStyle','none');%,'Color','m','LineStyle','.');

% whole year

donations = UVM_accum_data(2).data(1:end);
N = length(donations);
donations = sort(donations,'descend');

i=6;
if plotlogspace
    pts2plot=floor(logspace(0,log10(N),100)); 
else
    pts2plot=1:N;
end
line = plot(log10(1:N),log10(donations),'Color',0.7*[1 1 1]);
tmph(i) = plot(log10(pts2plot),log10(donations(pts2plot)),'Marker',tmpsym{i},'MarkerFaceColor',tmpcol{i},'LineStyle','none');%,'Color','k','LineStyle','.');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% plot the expected maximum gift lines

% where is the gift worth $18.19
wherex = [52 267 1938 7630 15404 31244];
biggest = [2731 21758 268864 1304123 3727918 9141988];

% plot each line
for i=1:6
    plot(log10([1 wherex(i)]),log10([biggest(i) 18.19]),'--','Color',tmpcol{i},'LineWidth',1.4);
end

%% legend
tmplh = legend(tmph,times,'northeast');
%set(tmplh,'position',get(tmplh,'position')-[.04 .03 0 0]) %% -[x y 0 0]
%% change font
tmplh = findobj(tmplh,'type','text');
set(tmplh,'FontSize',7);
%% remove box:
legend boxoff

% for use with layered plots
% set(gca,'box','off')

% adjust limits
% tmpv = axis;
% axis([]);
ylim([0 7]);
xlim([0 4.5]);

% fix up tickmarks
set(gca,'xtick',[0 1 2 3 4 4.5])
set(gca,'xticklabel',{'0','1','2','3','4','4.5'},'fontsize',8)




%% use latex interpreter for text, sans serif

tmpxlab=xlabel('$\log_{\,\,10}$ Gift rank $r$','fontsize',10,'verticalalignment','top','fontname','helvetica','interpreter','latex');
tmpylab=ylabel('$\log_{\,\,10}$ Gift size $S$','fontsize',11,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');

%% disp(get(tmpxlab,'position'))

set(tmpxlab,'position',get(tmpxlab,'position') - [0 .001 0]); % [x y 0]
set(tmpylab,'position',get(tmpylab,'position') - [0.1 0 0]);

addlabel3(' B ',.08,.11,13);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% print

%% automatic creation of postscript
%% without name/date
psprintcpdf_keeppostscript(tmpfilenoname);
%% keep postscript for publication
%% psprintcpdf_keeppostscript(tmpfilenoname);

%% automatic creation of postscript
%% psprintcpdf(tmpfilename);

tmpcommand = sprintf('open %s.pdf;',tmpfilenoname);
system(tmpcommand);

%% archivify
%figurearchivify(tmpfilenoname);

close(tmpfigh);

clear all

