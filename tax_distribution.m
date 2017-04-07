% todo:
% -resize the dots
clear all
load ../../data/taxdata

tmpfigh = gcf;
clf;
figshape(600,600);
% automatically create postscript whenever
% figure is drawn
tmpfilename = 'tax_distribution';

tmpfilenoname = sprintf('%s_noname',tmpfilename);

set(gcf,'DefaultAxesFontname','helvetica');
set(gcf,'DefaultAxesColor','none');
set(gcf,'DefaultLineMarkerSize',7);
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

%% rank is given in
ranks = taxdata(1).data;

label1 = taxdata(2).title; %% Income
income = taxdata(2).data;

line = plot(log10(ranks),log10(income),'Color',0.7*[1 1 1],'LineWidth',1.5);
hold on;

tmph(1) = plot(log10(ranks),log10(income),'Marker',tmpsym{1},'MarkerFaceColor',tmpcol{1},'LineStyle','none'); %'Color',[0.1328, 0.5430, 0.1328],'LineStyle','-');

[alpha,gamma]=plotpowerfit(ranks,income','Offset',-0.4,'method','LS');% ,'',1);

%% 
label2 = taxdata(4).title; %% Av Gift
av_gift = taxdata(4).data;

% this computes the adjusted ranks for the true average gifts
N=length(av_gift);
% assum_alpha=0.708257262433933; %0.708143106737829; %0.710534703339078; %0.657894736842105;
alpha_iter = 0.657894736842105;
ranks = [1;ranks];
disp(ranks)
for i=1:5
    fprintf('alpha is %f\n',alpha_iter);
    fprintf('the ranks are:\n');  
    for j=1:N
        % both of these methodologies work well now
        numgifts = ranks(j+1)-ranks(j) +1;
        newranks(j) = (sum((ranks(j):ranks(j+1)).^(-alpha_iter))/numgifts)^(-1/alpha_iter);
    end
    disp(newranks);
    [alpha_iter,~] = plotpowerfit(newranks(1:end),av_gift(1:end),'Offset',-0.4,'method','LS','Plotoff',1);
end

%%
line = plot(log10(newranks),log10(av_gift),'Color',0.7*[1 1 1],'LineWidth',1.5);

tmph(2) = plot(log10(newranks),log10(av_gift),'Marker',tmpsym{2},'MarkerFaceColor',tmpcol{2},'LineStyle','none');

offset2=-.4;    

[alpha2,gamma2]=plotpowerfit(newranks(1:end),av_gift(1:end),'Offset',-0.4,'method','LS');
csvwrite('tax_return_gifts_gamma.csv',gamma2);
set(gca,'fontsize',16);

%% legend
tmplh = legend(tmph,{'Income, 2001','Charitable Deduction, 2001'},'Location',[.62,.81,.1,.072]); % [left,bottom,width,height]

%set(tmplh,'position',get(tmplh,'position')-[0.03 0.03 0 0]) %% -[x y 0 0]
%% change font
%tmplh = findobj(tmplh,'type','text');
set(tmplh,'FontSize',17);
%% remove box:
legend boxoff

ylim([2 7.1]);
xlim([2.7 8.5]);

set(gca,'ytick',[2:1:7])
% set(gca,'xticklabel',{'','',''})

%% use latex interpreter for text, sans serif

tmpxlab=xlabel('$\log_{10}$ Rank individual $r$','fontsize',23,'verticalalignment','top','fontname','helvetica','interpreter','latex');
tmpylab=ylabel('$\log_{10}$ (Gift size $S$, Income $I$)','fontsize',23,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');

%% disp(get(tmpxlab,'position'))

set(tmpxlab,'position',get(tmpxlab,'position') - [0 .001 0]); % [x y 0]
set(tmpylab,'position',get(tmpylab,'position') - [0.1 0 0]);

tmpstr{1} = sprintf('\\alpha = %1.2f',alpha2);
tmpstr{2} = sprintf('\\gamma = %1.2f',gamma2);

text(.38,.32,tmpstr,...
         'fontsize',16,...
         'fontname','helvetica',...
         'units','normalized',...
         'interpreter','tex');
     
tmpstr{1} = sprintf('\\alpha = %1.2f',alpha);
tmpstr{2} = sprintf('\\gamma = %1.2f',gamma);

text(.55,.48,tmpstr,...
         'fontsize',16,...
         'fontname','helvetica',...
         'units','normalized',...
         'interpreter','tex');
     
psprintcpdf_keeppostscript(tmpfilenoname);

%% automatic creation of postscript
%% psprintcpdf(tmpfilename);

tmpcommand = sprintf('open %s.pdf;',tmpfilenoname); 
system(tmpcommand);

% system('epstopdf distribution-comparison001_noname.ps','-echo');
% system('open distribution-comparison001_noname.pdf');

%% archivify
%figurearchivify(tmpfilenoname);

close(tmpfigh);
clear tmp*

clear all