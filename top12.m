%% uses ../data/UVM_accumulation.mat
clear all

figure('visible','off');
set(gcf,'color','none');
tmpfigh = gcf;
clf;
figshape(500,500);
%% automatically create postscript whenever
%% figure is drawn
tmpfilename = 'top12';

tmpfilenoname = sprintf('%s_noname',tmpfilename);

%% global switches

set(gcf,'Color','none');
set(gcf,'InvertHardCopy', 'off');

set(gcf,'DefaultAxesFontname','helvetica');
set(gcf,'DefaultLineColor','r');
set(gcf,'DefaultAxesColor','none');
set(gcf,'DefaultLineMarkerSize',4.3);
set(gcf,'DefaultLineMarkerEdgeColor','k');
%set(gcf,'DefaultLineMarkerFaceColor','g');
set(gcf,'DefaultAxesLineWidth',0.5);
set(gcf,'PaperPositionMode','auto');

tmpsym = {'o','s','v','o','s','v'};
tmpcol = {'g','b','r','k','c','m'};

positions(1).box = [.2 .2 .7 .7];
axesnum = 1;
tmpaxes(axesnum) = axes('position',positions(axesnum).box);

%% main data goes here

% assume that the top 12 get 650,000, solve for c
j=0;
gammas=1.7:0.1:2.2;
for i=gammas
    j=j+1;
    tmp = sum((1:12).^(-1/(i-1)));
    c(j)=650000/tmp;
end

disp(c)

order = 2;

%% plot it
j=0;
N=5000;

for i=gammas
    j=j+1;
    %p = polyfit(income,data(i,:),order);
    %line = plot(log10(linspace(12500,500000,100)),polyval(p,linspace(12500,500000,100)),'Color',0.7*[1 1 1]);
    labels{j}=sprintf('%d',i); % num2str(i);
    
    total_raised = zeros(1,N);
    for k=1:N
        total_raised(k)=sum(c(j).*(1:k).^(-1/(i-1)));
    end
    
    plot(1:N,total_raised,'Color',0.7*[1 1 1]);
    hold on;
    tmph(j) = plot(1:100:N,total_raised(1:100:N),'Marker',tmpsym{mod(j,6)+1},'MarkerFaceColor',tmpcol{mod(j,6)+1},'LineStyle','none');
    % ,'MarkerEdgeColor',tmpcol{mod(j,6)+1}
end
    
set(gca,'fontsize',16);
set(gca,'color','none');


%% for use with layered plots
%% set(gca,'box','off')

%% adjust limits
%% tmpv = axis;
%% axis([]);
%ylim([-1,25]);
%xlim(log10([12000 510000]));

%% change axis line width (default is 0.5)
%% set(tmpaxes(axesnum),'linewidth',2)

%% fix up tickmarks
%set(gca,'xtick',log10(income))
%month_names={'J','F','M','A','M','J','J','A','S','O','N','D'};
%set(gca,'xticklabel',income,'fontsize',11)

set(gca,'ytick',1e6*[1,2,3]);
% for i=1:12
%   ylabels{i}=num2str(2*i);
% end
set(gca,'yticklabel',{'1','2','3'},'fontsize',12);

%% the following will usually not be printed 
%% in good copy for papers
%% (except for legend without labels)

%% remove a plot from the legend
%% set(get(get(tmph,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

%% legend
labels={'\gamma=1.7','\gamma=1.8','\gamma=1.9','\gamma=2.0','\gamma=2.1','\gamma=2.2'};
tmp1h = legend(tmph,labels,'location','northwest');
% %% tmplh = legend('','','');
%set(tmplh,'position',get(tmplh,'position')-[x y 0 0])
% %% change font
tmplh = findobj(tmp1h,'type','text');
set(tmp1h,'FontSize',12);
% %% remove box:
legend boxoff

%% use latex interpreter for text, sans serif

tmpxlab=xlabel('Number of Donors','fontsize',17,'fontname','helvetica','interpreter','latex','HorizontalAlignment','center');
tmpylab=ylabel('Total Raised, in millions','fontsize',16,'fontname','helvetica','interpreter','latex'); %,'VerticalAlignment','middle');

%set(tmpxlab,'position',get(tmpxlab,'position') - [0 100 0]);
%set(tmpylab,'position',get(tmpylab,'position') - [1001 100100 10010]);

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
clear tmp
clear tmph
