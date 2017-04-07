%% make fig 4 of the paper

load ../../data/inst_x.mat

%% figure('visible','off');

%% set(gcf,'color','none');
tmpfigh = gcf;
clf;
figshape(600,800);
% automatically create postscript whenever
% figure is drawn
tmpfilename = 'religious_inst';

tmpfilenoname = sprintf('%s_noname',tmpfilename);

%% global switches

%% set(gcf,'Color','none');
%% set(gcf,'InvertHardCopy', 'off');

set(gcf,'DefaultAxesFontname','helvetica');

set(gcf,'DefaultAxesColor','none');
set(gcf,'DefaultLineMarkerSize',10);
% set(gcf,'DefaultLineMarkerEdgeColor','k');
% set(gcf,'DefaultLineMarkerFaceColor','w');
% set(gcf,'DefaultAxesLineWidth',0.5);



set(gcf,'DefaultAxesFontname','helvetica');

set(gcf,'DefaultAxesColor','none');
set(gcf,'DefaultLineMarkerSize',5);
set(gcf,'DefaultLineMarkerEdgeColor','k');
set(gcf,'DefaultLineMarkerFaceColor','g');
set(gcf,'DefaultAxesLineWidth',0.5);
set(gcf,'PaperPositionMode','auto');


tmpsym = {'o','s','v','o','s','v'};
tmpcol = {'g','b','r','k','c','m'};


positions(1).box = [.2 .2 .7 .7]; % [ xmin ymin xmax ymax
axesnum = 1;
tmpaxes(axesnum) = axes('position',positions(axesnum).box);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% main data goes here

%% einstein is 2
for j=[1 2 3]
year = inst_x.years(j); %% 2008:1:2010
donations = inst_x.data(:,j);
if (min(donations==0)) 
  donations = donations(1:min(find(donations==0))-1);
end
N = length(donations); %% 7796

label{j}=num2str(year);

line = plot(log10(1:N),log10(donations),'Color',0.7*[1 1 1]);
hold on;

tmph(j) = plot(log10(1:N),log10(donations),'Marker',tmpsym{j},'MarkerFaceColor',tmpcol{j},'LineStyle','none');
  % 'Color', [0.5, 1.0, 0.0], 'LineStyle', '--'
end
%% united way is 4
% year2 = phdata(4).years(7); %% 2010
% name2 = phdata(4).name; %% United Way, Chittendon County
% donations2 = phdata(4).donations(:,1);
% if (min(donations2==0)) 
%   donations2 = donations2(1:min(find(donations2==0))-1);
% end
% N = length(donations2);
% 
% line = plot(log10(1:N),log10(donations2),'Color',0.7*[1 1 1]);
% 
% tmph(2) = plot(log10(1:N),log10(donations2),'Marker',tmpsym{2},'MarkerFaceColor',tmpcol{2},'LineStyle','none');

% hAnnotation = get(tmph2,'Annotation');
% hLegendEntry = get(hAnnotation','LegendInformation');
% set(hLegendEntry,'IconDisplayStyle','off')

%% plot some grey lines underneath
% einstein is 2
% year1 = phdata(2).years(5); %% 2010
% name1 = phdata(2).name; %% Einstein School of Medicine
% donations = phdata(2).donations(:,1);
% if (min(donations==0)) 
%   donations = donations(1:min(find(donations==0))-1);
% end
% N = length(donations); %% 7796
% 
% tmph = plot(log10(1:N),log10(donations),'Color',0.7*[1 1 1]);
% hold on;
% 
% % united way is 4
% year2 = phdata(4).years(7); %% 2010
% name2 = phdata(4).name; %% United Way, Chittendon County
% donations = phdata(4).donations(:,1);
% if (min(donations==0)) 
%   donations = donations(1:min(find(donations==0))-1);
% end
% N = length(donations);
% 
% tmph = plot(log10(1:N),log10(donations),'Color',0.7*[1 1 1]);

%%

set(gca,'fontsize',16);

% legend
tmp1h = legend(tmph,label);%,'Location',[.54,.79,.15,.072]); % [left,bottom,width,height]
%set(tmp1h,'position',get(tmp1h,'position')-[0 0 0 0]) %% -[x y 0 0]
%% change font
%tmplh = findobj(tmplh,'type','text');
%set(tmplh,'FontSize',16);
%% remove box:
legend boxoff


% for use with layered plots
% set(gca,'box','off')

% adjust limits
% tmpv = axis;
% axis([]);
ylim([0,6]);
% xlim([]);

% change axis line width (default is 0.5)
% set(tmpaxes(axesnum),'linewidth',2)

% fix up tickmarks
% set(gca,'xtick',[1 100 10^4])
% set(gca,'xticklabel',{'','',''})

% the following will usually not be printed 
% in good copy for papers
% (except for legend without labels)

%% remove a plot from the legend
%% set(get(get(tmph,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');



%% use latex interpreter for text, sans serif

tmpxlab=xlabel('$\log_{10}$ Gift rank $r$','fontsize',21,'verticalalignment','top','fontname','helvetica','interpreter','latex');
tmpylab=ylabel('$\log_{10}$ Gift size $S$','fontsize',21,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');

%% disp(get(tmpxlab,'position'))

set(tmpxlab,'position',get(tmpxlab,'position') - [0 .001 0]); % [x y 0]
set(tmpylab,'position',get(tmpylab,'position') - [0.1 0 0]);

% set 'units' to 'data' for placement based on data points
% set 'units' to 'normalized' for relative placement within axes
% tmpXcoord = ;
% tmpYcoord = ;
% tmpstr = sprintf('\\sffamily ');
% or
% tmpstr{1} = sprintf('\\sffamily ');
% tmpstr{2} = sprintf('\\sffamily ');
%
% text(tmpXcoord,tmpYcoord,tmpstr,...
%     'fontsize',20,...
%     'fontname','helvetica',...
%     'units','normalized',...
%     'interpreter','latex',...
%      )

% label (A, B, ...)
% addlabel2(' A ',0.02,0.9,20);

% or:
% tmplabelXcoord= 0.015;
% tmplabelYcoord= 0.88;
% tmplabelbgcolor = 0.85;
% tmph = text(tmplabelXcoord,tmplabelYcoord,' A ','Fontsize',24,'fontname','helvetica',...
%         'units','normalized');
%    set(tmph,'backgroundcolor',tmplabelbgcolor*[1 1 1]);
%    set(tmph,'edgecolor',[0 0 0]);
%    set(tmph,'linestyle','-');
%    set(tmph,'linewidth',1);
%    set(tmph,'margin',1);


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
%% psprintcpdf(tmpfilenoname);
%% keep postscript for publication

psprintcpdf(tmpfilenoname);

%% name label
%% 
%% don't need it -andy
% 
% tmpt = pwd;
% tmpnamememo = sprintf('[source=%s/%s.ps]',tmpt,tmpfilename);
% 
% [tmpXcoord,tmpYcoord] = normfigcoords(1.05,.05);
% text(tmpXcoord,tmpYcoord,tmpnamememo,...
%      'units','normalized',...
%      'fontsize',2,...
%      'rotation',90,'color',0.8*[1 1 1]);
% 
% [tmpXcoord,tmpYcoord] = normfigcoords(1.1,.05);
% datenamer(tmpXcoord,tmpYcoord,90);

%% automatic creation of postscript
%% psprintcpdf(tmpfilename);

tmpcommand = sprintf('open %s.pdf;',tmpfilenoname); 
system(tmpcommand);

% system('epstopdf distribution-comparison001_noname.ps','-echo');
% system('open distribution-comparison001_noname.pdf');

%% archivify
%% figurearchivify(tmpfilenoname);

close(tmpfigh);
%clear tmp*
