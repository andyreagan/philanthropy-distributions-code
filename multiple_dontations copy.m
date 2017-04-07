%% uses ../data/UVM_accumulation.mat
figure('visible','off');
set(gcf,'color','none');
tmpfigh = gcf;
clf;
figshape(350,500);
%% automatically create postscript whenever
%% figure is drawn
tmpfilename = 'multiple_gifts';

tmpfilenoname = sprintf('%s_noname',tmpfilename);

%% global switches

set(gcf,'Color','none');
set(gcf,'InvertHardCopy', 'off');

set(gcf,'DefaultAxesFontname','helvetica');
set(gcf,'DefaultLineColor','r');
set(gcf,'DefaultAxesColor','none');
set(gcf,'DefaultLineMarkerSize',3);
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

% make artificial data
c=10000; % biggest gift
N=1875; % number of gifts following power law
N2=5000; % total number of gifts
alpha=0.65; % corresponding to gamma=2.52

donors = 1:N2;
gifts = zeros(1,N2);
for i=1:N
    gifts(i)=c.*(i).^(-alpha);
end
for i=N+1:N2
    gifts(i)=c.*(N).^(-alpha).*((N2-i)./(N2-N));
end
    
line = plot(log10(donors),log10(gifts),'Color',0.7*[1 1 1]);
hold on;
tmph(1) = plot(log10(donors),log10(gifts),'Marker',tmpsym{1},'MarkerEdgeColor',tmpcol{1},'MarkerFaceColor',tmpcol{1},'LineStyle','none');

% now we'll split the gifts into 1/4 and 3/4

% there will be twice as many gifts
N2=2*N2; 
tmp_gifts = .25.*gifts; % the smaller parts
tmp2_gifts = .75.*gifts; % the bigger parts
donors = 1:N2;
gifts = zeros(1,N2);
for i=1:N2/2
    gifts(i)=tmp_gifts(i);
    gifts(i+N2/2)=tmp2_gifts(i);
end
gifts=sort(gifts,'descend');

line = plot(log10(donors),log10(gifts),'Color',0.7*[1 1 1]);
hold on;
tmph(2) = plot(log10(donors),log10(gifts),'Marker',tmpsym{2},'MarkerEdgeColor',tmpcol{2},'MarkerFaceColor',tmpcol{2},'LineStyle','none');


set(gca,'fontsize',16);
set(gca,'color','none');

%% for use with layered plots
%% set(gca,'box','off')

%% adjust limits
%% tmpv = axis;
%% axis([]);

ylim([0,4]);
xlim([0,4]);

%% change axis line width (default is 0.5)
%% set(tmpaxes(axesnum),'linewidth',2)

%% fix up tickmarks
%set(gca,'xtick',months_cum_rank)
%month_names={'J','F','M','A','M','J','J','A','S','O','N','D'};
%set(gca,'xticklabel',month_names)

% set(gca,'ytick',1e6:2e6:2.4e7);
% for i=1:12
%   ylabels{i}=num2str(2*i);
% end
% set(gca,'yticklabel',ylabels);

%% the following will usually not be printed 
%% in good copy for papers
%% (except for legend without labels)

%% remove a plot from the legend
%% set(get(get(tmph,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

%% legend
tmplh = legend(tmph,'Reference','Multiple Gifts');
%% tmplh = legend('','','');
%set(tmplh,'position',get(tmplh,'position')-[-.2 -.3 .15 .15]); %[-.2 -0.089 .15 .15])
%% change font
tmplh = findobj(tmplh,'type','text');
set(tmplh,'FontSize',11);
%% remove box:
legend boxoff

%% use latex interpreter for text, sans serif

tmpxlab=xlabel('$\log _{10}$ Rank $r$','fontsize',18,'verticalalignment','top','fontname','helvetica','interpreter','latex');
tmpylab=ylabel('$\log _{10}$ Donations $d$','fontsize',16,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');

set(tmpxlab,'position',get(tmpxlab,'position') - [0 .1 0]);
%% set(tmpylab,'position',get(tmpylab,'position') - [.1 0 0]);

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
% clear all