%% make fig 4 of the paper
clear all

load ../../data/phdata.mat

%% figure('visible','off');

%% set(gcf,'color','none');
tmpfigh = gcf;
clf;
figshape(600,600);
% automatically create postscript whenever
% figure is drawn
tmpfilename = 'distribution-comparison001';

tmpfilenoname = sprintf('%s_noname',tmpfilename);

%% global switches

set(gcf,'Color','none');
set(gcf,'InvertHardCopy', 'off');

set(gcf,'DefaultAxesFontname','helvetica');
set(gcf,'DefaultLineColor','r');
set(gcf,'DefaultAxesColor','none');
set(gcf,'DefaultLineMarkerSize',5);
set(gcf,'DefaultLineMarkerEdgeColor','k');
set(gcf,'DefaultLineMarkerFaceColor','g');
set(gcf,'DefaultAxesLineWidth',0.5);
set(gcf,'PaperPositionMode','auto');

tmpsym = {'o','s','v','o','s','v'};
tmpcol = {'g','b','r','k','c','m'};

positions(1).box = [.2 .2 .7 .7];
axesnum = 1;
tmpaxes(axesnum) = axes('position',positions(axesnum).box);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% main data goes here



%% einstein is 2nd entry in phdata
year1 = phdata(2).years(5); %% 2010
name1 = phdata(2).name; %% Einstein School of Medicine
donations = phdata(2).donations(:,5);
if (min(donations==0)) 
  donations = donations(1:min(find(donations==0))-1);
end
% N = length(donations); %% 7796
 
%% united way is 4th entry in phdata
year2 = phdata(4).years(7); %% 2010
name2 = phdata(4).name; %% United Way, Chittendon County
donations2 = phdata(4).donations(:,7);
if (min(donations2==0)) 
  donations2 = donations2(1:min(find(donations2==0))-1);
end

%% plot the fits

fit_lower=[1 1]; 
fit_upper=[2000 floor(10^2.5)]; 
offset=[.5 -.5 ];
i=1;
[alphas(i),gammas(i)]=plotpowerfit(fit_lower(i):fit_upper(i),donations(fit_lower(i):fit_upper(i)),'Offset',offset(i),'method','clauset','gammaconfrep',2,'prep',2);
i=2;
[alphas(i),gammas(i)]=plotpowerfit(fit_lower(i):fit_upper(i),donations2(fit_lower(i):fit_upper(i)),'Offset',offset(i),'method','clauset','gammaconfrep',2,'prep',2);


%% make the first line and points

line = plot(log10(1:length(donations)),log10(donations),'Color',0.7*[1 1 1],'LineWidth',1.5);
hold on;

% plot points evenly in log space
pts2plot = spacepts(1,length(donations),60,1);

tmph(1) = plot(log10(pts2plot),log10(donations(pts2plot)),'Marker',tmpsym{1},'MarkerFaceColor',tmpcol{1},'LineStyle','none');
  % 'Color', [0.5, 1.0, 0.0], 'LineStyle', '--'

  
%% make the second line and points
line = plot(log10(1:length(donations2)),log10(donations2),'Color',0.7*[1 1 1],'LineWidth',1.5);

% plot points evenly in log space
pts2plot = spacepts(1,length(donations2),60,1);

tmph(2) = plot(log10(pts2plot),log10(donations2(pts2plot)),'Marker',tmpsym{2},'MarkerFaceColor',tmpcol{2},'LineStyle','none');



%%

set(gca,'fontsize',16);

% legend
tmp1h = legend(tmph,sprintf('%s, %d',name1,year1),sprintf('%s, %d',name2,year2),'Location',[.53,.81,.15,.072]); % [left,bottom,width,height]
%set(tmp1h,'position',get(tmp1h,'position')-[0 0 0 0]) %% -[x y 0 0]
%% change font
%tmplh = findobj(tmplh,'type','text');
set(tmp1h,'FontSize',17);
%% remove box:
legend boxoff

%% use latex interpreter for text, sans serif

tmpxlab=xlabel('$\log_{10}$ Gift rank $r$','fontsize',23,'verticalalignment','top','fontname','helvetica','interpreter','latex');
tmpylab=ylabel('$\log_{10}$ Gift size $S$','fontsize',23,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');

%% disp(get(tmpxlab,'position'))

set(tmpxlab,'position',get(tmpxlab,'position') - [0 .001 0]); % [x y 0]
set(tmpylab,'position',get(tmpylab,'position') - [0.1 0 0]);




i=1;
tmpstr{1}=sprintf('\\alpha = %1.2f',alphas(i));
tmpstr{2}=sprintf('\\gamma = %1.2f',gammas(i));
whereY=[.61 .31];
whereX=[.62 .35];
text(whereX(i),whereY(i),tmpstr,...
    'fontsize',16,...
    'fontname','helvetica',...
    'units','normalized',...
    'interpreter','tex');

i=2;
tmpstr{1}=sprintf('\\alpha = %1.2f',alphas(i));
tmpstr{2}=sprintf(' \\gamma = %1.2f',gammas(i));
text(whereX(i),whereY(i),tmpstr,...
    'fontsize',16,...
    'fontname','helvetica',...
    'units','normalized',...
    'interpreter','tex');

%% keep postscript for publication

psprintcpdf_keeppostscript(tmpfilenoname);

%% automatic creation of postscript
%% psprintcpdf(tmpfilename);

tmpcommand = sprintf('open %s.pdf;',tmpfilenoname); 
system(tmpcommand);

%% archivify
%figurearchivify(tmpfilenoname);

close(tmpfigh);
clear all