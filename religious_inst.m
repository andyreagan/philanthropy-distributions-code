%% make fig 4 of the paper

load ../../data/inst_x.mat

powerlabelsize = 18;
pointersize = 25;
figuresize = 18;
labelsize = 28;
legendsize = 18;

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


positions(1).box = [.15 .2 .7 .68]; % [ xmin ymin xmax ymax
axesnum = 1;
tmpaxes(axesnum) = axes('position',positions(axesnum).box);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% main data goes here

% plot the area filled first
donations = inst_x.data(:,3);
if (min(donations==0))
    donations = donations(1:min(find(donations==0))-1);
end
% make artificial data
c=100000; % biggest gift
N=1875; % number of gifts following power law
N2=2000; % total number of gifts
alpha=0.99; % corresponding to gamma=2.52

donors = 1:N2;
gifts = zeros(1,N2);
for i=1:N
    gifts(i)=c.*(i).^(-alpha);
end
for i=N+1:N2
    gifts(i)=c.*(N).^(-alpha).*((N2-i)./(N2-N));
end
%line = plot(log10(donors),log10(gifts),'Color',0.7*[1 1 1]);


X=log10([donors(2:100),fliplr(donors(2:100))]);                %#create continuous x value array for plotting
Y=log10([gifts(2:100),fliplr(donations(2:100)')]);   %#create y values for out and then back
fill(X,Y,[153 204 255]/255); 
hold on;
set(gca,'fontsize',16);
a = annotation('textarrow', [.47 .35], [.80 .66], 'String' , 'A','fontsize',pointersize,'Color',0.01*[1 1 1]);

X=log10([donors(1500:1999),fliplr(1000:length(donations))]);                %#create continuous x value array for plotting
Y=log10([gifts(1500:1999),fliplr(donations(1000:end)')]);   %#create y values for out and then back
fill(X,Y,[153 204 255]/255); 
b = annotation('textarrow', [.55 .71], [.28 .28], 'String' , 'B','fontsize',pointersize,'Color',0.01*[1 1 1]);

%area(log10(donors(2:100)),log10(gifts(2:100))); % ,relig_donations(2:100));
    
    
    
%% plot the actual data
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




set(gca,'fontsize',figuresize);

% legend
tmp1h = legend(tmph,label);%,'Location',[.54,.79,.15,.072]); % [left,bottom,width,height]
set(tmp1h,'position',get(tmp1h,'position')-[0.05 0.05 0 0]) %% -[x y 0 0]
%% change font
%tmplh = findobj(tmplh,'type','text');
set(tmp1h,'FontSize',legendsize);
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

tmpxlab=xlabel('$\log_{10}$ Gift rank $r$','fontsize',labelsize,'verticalalignment','top','fontname','helvetica','interpreter','latex');
tmpylab=ylabel('$\log_{10}$ Gift size $S$','fontsize',labelsize,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');

%% disp(get(tmpxlab,'position'))

set(tmpxlab,'position',get(tmpxlab,'position') - [0 .001 0]); % [x y 0]
set(tmpylab,'position',get(tmpylab,'position') - [0.1 0 0]);

%% fake power law fit

% plot([1.57 3.2],[3.7 2.1],'k--');
% 


%% real power law fit

% don't try to make this look nice, just find the gamma?
offset=0.3;
fitregion=110:1800;
[alpha,gamma]=plotpowerfit(fitregion,donations(fitregion),110,1800,offset);

clear tmptxt

tmptxt{1} =sprintf('\\alpha = %1.2f',alpha);
tmptxt{2} =sprintf('\\gamma = %1.2f',gamma);
text(.65,.53,tmptxt,...
         'fontsize',powerlabelsize,...
         'fontname','helvetica',...
         'units','normalized',...
         'interpreter','tex');




%% automatic creation of postscript
%% without name/date
%% psprintcpdf(tmpfilenoname);
%% keep postscript for publication

psprintcpdf(tmpfilenoname);

%% automatic creation of postscript
%% psprintcpdf(tmpfilename);

tmpcommand = sprintf('open %s.pdf;',tmpfilenoname);
system(tmpcommand);

% system('epstopdf distribution-comparison001_noname.ps','-echo');
% system('open distribution-comparison001_noname.pdf');

%% archivify
figurearchivify(tmpfilenoname);

close(tmpfigh);
%clear tmp*
