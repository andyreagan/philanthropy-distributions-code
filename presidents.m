%% make figure of presenditial data of the paper
%% making it on one graph
clear all;
load ../../data/presdata

fit = 'LS';

figure('visible','off');

%% set(gcf,'color','none');
tmpfigh = gcf;
clf;
figshape(600,600);
% automatically create postscript whenever
% figure is drawn
tmpfilename = 'presidents';

tmpfilenoname = sprintf('%s_noname',tmpfilename);

%% global switches

%% set(gcf,'Color','none');
%% set(gcf,'InvertHardCopy', 'off');

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

positions(1).box = [.2 .2 .7 .7]; % [ xmin ymin xmax ymax
axesnum = 1;
tmpaxes(axesnum) = axes('position',positions(axesnum).box);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% main data goes here

j=1;
order=[6 3 5 1 2 4];
offset=.5;

MLE_data_cell = cell(1,8);
LS_data_cell = cell(1,6);
for i=1:8 % p gof fit_l fit_u gamma gamma_conf alpha alpha_conf
    MLE_data_cell{i} = zeros(1,6);
end
for i=1:6 % fit_l fit_u gamma gamma_conf alpha alpha_conf
    LS_data_cell{i} = zeros(1,6);
end

tmpleg = cell(1,6);
for i=1:6
    tmpleg{i}=sprintf('%s, %d',presdata(i).name,presdata(i).year);
    donations=presdata(i).donations; %(:,1)
    N = length(donations);
    line = plot(log10(1:N),log10(donations),'Color',tmpcol{i},'LineWidth',2); %,'Color',0.7*[1 1 1]);
    hold on;
    tmph(i) = plot(log10(1:N),log10(donations),'Marker',tmpsym{i},'MarkerFaceColor',tmpcol{i},'LineStyle','none'); %'Color',[0.1328, 0.5430, 0.1328],
    % 'Color', [0.5, 1.0, 0.0], 'LineStyle', '--'
    
    %% parameter fit, plot one
    fprintf('fitting %s\n',presdata(i).name);
    
    [alpha_LS,gamma_LS,alpha_conf_LS,gamma_conf_LS]=plotpowerfit(1:length(donations),donations,'Plotoff','yes','method','LS');
    
    if i==1 % plot, and save the fit, for the first one
        [alpha,gamma,alpha_conf,gamma_conf,p,gof]=plotpowerfit(1:length(donations),donations,'Offset',offset,'method','clauset','gammaconfrep',2,'prep',2);
    else % save the data regardless of plotswitch
        % try at least three times (write a recursive try function next?)
        try
            [alpha,gamma,alpha_conf,gamma_conf,p,gof]=plotpowerfit(1:length(donations),donations,'Plotoff','yes','method','clauset','gammaconfrep',2,'prep',2);
        catch
            try
                [alpha,gamma,alpha_conf,gamma_conf,p,gof]=plotpowerfit(1:length(donations),donations,'Plotoff','yes','method','clauset','gammaconfrep',2,'prep',2);
            catch
                [alpha,gamma,alpha_conf,gamma_conf,p,gof]=plotpowerfit(1:length(donations),donations,'Plotoff','yes','method','clauset','gammaconfrep',2,'prep',2);
            end
        end      
    end
    fit_lower = 1;
    fit_upper = length(donations);
    
    MLE_data = [p,gof,fit_lower,fit_upper,gamma,gamma_conf,alpha,alpha_conf];
    LS_data = [fit_lower,fit_upper,gamma_LS,gamma_conf_LS,alpha_LS,alpha_conf_LS];
    for k=1:8
        MLE_data_cell{k}(i) = MLE_data(k);
    end
    for k=1:6
        LS_data_cell{k}(i) = LS_data(k);
    end
end

set(gca,'fontsize',16);

%% legend
tmplegend = legend(tmph,tmpleg,'location','northeast'); % {6},tmpleg{3},tmpleg{5},tmpleg{1},tmpleg{2},tmpleg{4}
set(tmplegend,'position',get(tmplegend,'position')-[.02 0.02 0 0]); %% -[x y 0 0]
%% change font
tmplegend = findobj(tmplegend,'type','text');
set(tmplegend,'FontSize',16);
%% remove box:
legend boxoff

%% use latex interpreter for text, sans serif

tmpxlab=xlabel('$\log_{\,10}$ Gift rank $r$','fontsize',21,'verticalalignment','top','fontname','helvetica','interpreter','latex');
tmpylab=ylabel('$\log_{\,10}$ Gift size $S$','fontsize',21,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');

%% disp(get(tmpxlab,'position'))

%set(tmpxlab,'position',get(tmpxlab,'position') - [0 .001 0]); % [x y 0]
%set(tmpylab,'position',get(tmpylab,'position') - [0.1 0 0]);

%% plot fit* (not really a fit)

% plot([0.25 1.25],[5.5 4.1],'k--');

% text(.33,.7,'\gamma = 1.71',...
%          'fontsize',15,...
%          'fontname','helvetica',...
%          'units','normalized',...
%          'interpreter','tex');

i=1;
tmpstr{1}=sprintf('\\alpha = %1.2f',LS_data_cell{5}(1));
tmpstr{2}=sprintf('\\gamma = %1.2f',1+1/LS_data_cell{5}(1));
whereY=[.61 .31]+[1 1]*.18;
whereX=[.62 .35]+[1 1]*(-.31);
text(whereX(i),whereY(i),tmpstr,...
    'fontsize',16,...
    'fontname','helvetica',...
    'units','normalized',...
    'interpreter','tex');

%% automatic creation of postscript
%% without name/date
%% psprintcpdf(tmpfilenoname);
%% keep postscript for publication

psprintcpdf_keeppostscript(tmpfilenoname);

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
%figurearchivify(tmpfilenoname);

close(tmpfigh);

saved_variables = {'p','gof','fit_l','fit_u','gamma','gamma_conf','alpha','alpha_conf'};
method = 'MLE';
for i=1:8
    csvwrite(sprintf('pres_%s_%s.csv',saved_variables{i},method),MLE_data_cell{i});
end
method = 'LS';
for i=1:6
    csvwrite(sprintf('pres_%s_%s.csv',saved_variables{i+2},method),LS_data_cell{i});
end