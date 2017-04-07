%% uses ../data/UVM_accumulation.mat
clear all
figure('visible','off');
set(gcf,'color','none');
tmpfigh = gcf;
clf;
figshape(500,500);
%% automatically create postscript whenever
%% figure is drawn
tmpfilename = 'UVM_accumulation';

tmpfilenoname = sprintf('%s_noname',tmpfilename);

%% global switches

set(gcf,'Color','none');
set(gcf,'InvertHardCopy', 'off');

set(gcf,'DefaultAxesFontname','helvetica');
set(gcf,'DefaultLineColor','r');
set(gcf,'DefaultAxesColor','none');
set(gcf,'DefaultLineMarkerSize',4.3);
set(gcf,'DefaultLineMarkerEdgeColor',[0 128/255 0]);
set(gcf,'DefaultLineMarkerFaceColor','g');
set(gcf,'DefaultAxesLineWidth',0.5);
set(gcf,'PaperPositionMode','auto');

tmpsym = {'o','s','v','o','s','v'};
tmpcol = {[0 128/255 0],'b','r','k','c','m'};

positions(1).box = [.2 .2 .5 .5];
axesnum = 1;
tmpaxes(axesnum) = axes('position',positions(axesnum).box);

%% main data goes here
load ../../data/UVM_accum_data

dates=UVM_accum_data(1).data;
donations=UVM_accum_data(2).data;
total_donations=UVM_accum_data(3).data;

% plot this linearly
% plot(dates,total_donations);

% plot it by rank of gift
plot(1:length(total_donations),total_donations,'Color',0.7*[1 1 1]);
hold on;
plot(1:length(total_donations),total_donations,'Marker',tmpsym{1},'MarkerFaceColor',tmpcol{1},'LineStyle','none');


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
  %line([0 1],[0 1],1);
  plot([months_cum_rank(i) months_cum_rank(i)],[0.00001 2.4e7],'LineWidth',.3,'Color',0.7*[0 0 1],'LineStyle','--'); %,'r');%,'LineWidth',.5);
end

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
set(gca,'xticklabel',month_names,'fontsize',11)

set(gca,'ytick',1e6:2e6:2.4e7);
for i=1:12
  ylabels{i}=num2str(2*i);
end
set(gca,'yticklabel',ylabels,'fontsize',11);

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

tmpxlab=xlabel('Months','fontsize',17,'fontname','helvetica','interpreter','latex','HorizontalAlignment','center');
tmpylab=ylabel('Total Donations, in Millions','fontsize',16,'fontname','helvetica','interpreter','latex'); %,'VerticalAlignment','middle');

set(tmpxlab,'position',get(tmpxlab,'position') - [0 100 0]);
set(tmpylab,'position',get(tmpylab,'position') - [1001 100100 10010]);

%% set 'units' to 'data' for placement based on data points
%% set 'units' to 'normalized' for relative placement within axes
%% tmpXcoord = ;
%% tmpYcoord = ;
%% tmpstr = sprintf('\\sffamily ');
%% or
%% tmpstr{1} = sprintf('\\sffamily ');
%% tmpstr{2} = sprintf('\\sffamily ');
%%
%% text(tmpXcoord,tmpYcoord,tmpstr,...
%%     'fontsize',20,...
%%     'fontname','helvetica',...
%%     'units','normalized',...
%%     'interpreter','latex',...
%%      )

%% label (A, B, ...)
%% addlabel2(' A ',0.02,0.9,20);

%% or:
%% tmplabelXcoord= 0.015;
%% tmplabelYcoord= 0.88;
%% tmplabelbgcolor = 0.85;
%% tmph = text(tmplabelXcoord,tmplabelYcoord,' A ','Fontsize',24,'fontname','helvetica',...
%%         'units','normalized');
%%    set(tmph,'backgroundcolor',tmplabelbgcolor*[1 1 1]);
%%    set(tmph,'edgecolor',[0 0 0]);
%%    set(tmph,'linestyle','-');
%%    set(tmph,'linewidth',1);
%%    set(tmph,'margin',1);


%% rarely used (text command is better)
%% title('\sffamily ','fontsize',24,'interpreter','latex')
%% 'horizontalalignment','left');
%% tmpxl = xlabel('','fontsize',24,'verticalalignment','top');
%% set(tmpxl,'position',get(tmpxl,'position') - [ 0 .1 0]);
%% tmpyl = ylabel('','fontsize',24,'verticalalignment','bottom');
%% set(tmpyl,'position',get(tmpyl,'position') - [ 0.1 0 0]);
%% title('','fontsize',24)

%% automatic creation of postscript
%% without name/date
psprintcpdf(tmpfilenoname);
%% keep postscript for publication
%% psprintcpdf_keeppostscript(tmpfilenoname);

%% name label
%tmpt = pwd;
%tmpnamememo = sprintf('[source=%s/%s.ps]',tmpt,tmpfilename);

%[tmpXcoord,tmpYcoord] = normfigcoords(1.05,.05);
%text(tmpXcoord,tmpYcoord,tmpnamememo,...
%     'units','normalized',...
%     'fontsize',2,...
%     'rotation',90,'color',0.8*[1 1 1]);

%[tmpXcoord,tmpYcoord] = normfigcoords(1.1,.05);
%datenamer(tmpXcoord,tmpYcoord,90);

%% automatic creation of postscript
%% psprintcpdf(tmpfilename);

tmpcommand = sprintf('open %s.pdf;',tmpfilenoname);
system(tmpcommand);

%% archivify
figurearchivify(tmpfilenoname);

close(tmpfigh);
clear all
