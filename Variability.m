clear all

%% uses ../data/UVM_accumulation.mat
figure('visible','off');
set(gcf,'color','none');
tmpfigh = gcf;
clf;
figshape(500,500);
%% automatically create postscript whenever
%% figure is drawn
tmpfilename = 'Variability';

tmpfilenoname = sprintf('%s_noname',tmpfilename);

%% global switches

set(gcf,'Color','none');
set(gcf,'InvertHardCopy', 'off');

set(gcf,'DefaultAxesFontname','helvetica');
set(gcf,'DefaultLineColor','r');
set(gcf,'DefaultAxesColor','none');
set(gcf,'DefaultLineMarkerSize',7);
set(gcf,'DefaultLineMarkerEdgeColor','k');
set(gcf,'DefaultLineMarkerFaceColor','g');
set(gcf,'DefaultAxesLineWidth',0.5);
set(gcf,'PaperPositionMode','auto');

tmpsym = {'o','s','v','o','s','v'};
tmpcol = {'g','b','r','k','c','m'};

positions(1).box = [.2 .2 .7 .5];
axesnum = 1;
tmpaxes(axesnum) = axes('position',positions(axesnum).box);

%% main data goes here

data = [14765494.43 34058459.98 68047746.00 30313115.00 27348675.00;
22110723.87 25861822.30 24632940.71 17651038.14 23164450.95;
1913783.47 2071410.79 2432802.74 2498896.68 2595079.43;
558481.47 618975.11 568911.81 557205.20 622705.33];

% simple:
% tmph(1) = plot(2006:1:2010,log10(data(1,:)));
% hold on;
% 
% tmph(2) = plot(2006:1:2010,log10(data(2,:)));
% 
% tmph(3) = plot(2006:1:2010,log10(data(3,:)));
% 
% tmph(4) = plot(2006:1:2010,log10(data(4,:)));

tmplinecolor = 0.6*[1 1 1];
tmplinewidth = 2;

line = plot(2006:1:2010,log10(data(1,:)),'Color',tmplinecolor,'LineWidth',tmplinewidth);
hold on;
tmph(1) = plot(2006:1:2010,log10(data(1,:)),'Marker',tmpsym{1},'MarkerFaceColor',tmpcol{1},'LineStyle','none');

line = plot(2006:1:2010,log10(data(2,:)),'Color',tmplinecolor,'LineWidth',tmplinewidth);
tmph(2) = plot(2006:1:2010,log10(data(2,:)),'Marker',tmpsym{2},'MarkerFaceColor',tmpcol{2},'LineStyle','none');

line = plot(2006:1:2010,log10(data(3,:)),'Color',tmplinecolor,'LineWidth',tmplinewidth);
tmph(3) = plot(2006:1:2010,log10(data(3,:)),'Marker',tmpsym{3},'MarkerFaceColor',tmpcol{3},'LineStyle','none');

line = plot(2006:1:2010,log10(data(4,:)),'Color',tmplinecolor,'LineWidth',tmplinewidth);
tmph(4) = plot(2006:1:2010,log10(data(4,:)),'Marker',tmpsym{4},'MarkerFaceColor',tmpcol{4},'LineStyle','none');

set(gca,'fontsize',17);
set(gca,'color','none');

%% for use with layered plots
%% set(gca,'box','off')

%% adjust limits
%% tmpv = axis;
%% axis([]);

ylim([5.5 8]);
%xlim([0,length(total_donations)]);

%% change axis line width (default is 0.5)
%% set(tmpaxes(axesnum),'linewidth',2)

%% fix up tickmarks
%set(gca,'xtick',months_cum_rank)
%month_names={'J','F','M','A','M','J','J','A','S','O','N','D'};
%set(gca,'xticklabel',month_names)

set(gca,'ytick',6:8);
% for i=1:12
%   ylabels{i}=num2str(2*i);
% end
set(gca,'yticklabel',{'6','7','8'});

%% the following will usually not be printed 
%% in good copy for papers
%% (except for legend without labels)

%% remove a plot from the legend
%% set(get(get(tmph,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

%% legend
gammas = csvread('inst_gamma_MLE.csv');
disp(gammas);
legendcell = {sprintf('Einstein School of Medicine (\\gamma \\approx %.02f)',mean(gammas(1:5,2))),...
    sprintf('University of Vermont ( \\gamma \\approx %.02f)',mean(gammas(1:5,3))),...
    sprintf('United Way of Chittenden County ( \\gamma  \\approx %.02f)',mean(gammas(1:7,4))),...
    sprintf('Flynn Theater ( \\gamma \\approx %.02f)',mean(gammas(1:5,6)))};
tmplh = legend(tmph,legendcell);
%% tmplh = legend('','','');
set(tmplh,'position',get(tmplh,'position')-[-.24 -.34 .15 .15]); %[-.2 -0.089 .15 .15])
%% change font
tmplh = findobj(tmplh,'type','text');
set(tmplh,'FontSize',16);
%% remove box:
legend boxoff

%% use latex interpreter for text, sans serif

tmpxlab=xlabel('Years','fontsize',23,'verticalalignment','top','fontname','helvetica','interpreter','latex');
tmpylab=ylabel('$\log _{10}$ (Donations)','fontsize',23,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');

set(tmpxlab,'position',get(tmpxlab,'position') - [0 .1 0]);
%% set(tmpylab,'position',get(tmpylab,'position') - [.1 0 0]);

%% automatic creation of postscript
%% without name/date
psprintcpdf_keeppostscript(tmpfilenoname);

tmpcommand = sprintf('open %s.pdf;',tmpfilenoname);
system(tmpcommand);

%% archivify
%figurearchivify(tmpfilenoname);

close(tmpfigh);
clear all
