%% uses ../data/UVM_accumulation.mat
clear all

figure('visible','off');
set(gcf,'color','none');
tmpfigh = gcf;
clf;
figshape(500,670);
%% automatically create postscript whenever
%% figure is drawn
tmpfilename = 'transforming_ratio';

tmpfilenoname = sprintf('%s_noname',tmpfilename);

%% global switches

set(gcf,'Color','none');
set(gcf,'InvertHardCopy', 'off');

set(gcf,'DefaultAxesFontname','helvetica');
set(gcf,'DefaultLineColor','r');
set(gcf,'DefaultAxesColor','none');
set(gcf,'DefaultLineMarkerSize',6);
set(gcf,'DefaultLineMarkerEdgeColor','k');
%set(gcf,'DefaultLineMarkerFaceColor','g');
set(gcf,'DefaultAxesLineWidth',0.5);
set(gcf,'PaperPositionMode','auto');

tmpsym = {'o','s','v','o','s','v'};
tmpcol = {'g','b','r','k','c','m'};

positions(1).box = [.2 .2 .7 .5];
axesnum = 1;
tmpaxes(axesnum) = axes('position',positions(axesnum).box);

%% main data goes here

income = [12500 25000 50000 100000 250000 500000];
data = [0.490842928 1 2.28731162 5.09263274 10.63326572 21.6632758;
    0.652015752 1 1.533705278 2.699475339 4.140199576 6.349845944;
    0.711928332 1 1.404635769 2.201062401 3.091690977 4.342699731;
    0.916415696 1 1.091207848 1.224668211 1.336367564 1.458254774;
    1 1 1 1 1 1;
    1.480120143 1 0.67562083 0.402330246 0.271822695 0.183649075];

gamma_ref = csvread('tax_return_gifts_gamma.csv');
gamma_relig = csvread('relig_inst_corrected_gamma.csv');

gammas_all = csvread('inst_gamma_MLE.csv');
disp(gammas_all);
gammas = [mean(gammas_all(1:2,1)),...
    mean(gammas_all(1:5,2)),...
    mean(gammas_all(1:5,3)),...
    mean(gammas_all(3:7,4)),...
    mean(gammas_all(1:5,5)),...
    mean(gammas_all(1:5,6))];
disp(gammas);
titles_tmp = {sprintf('Education, \\gamma \\approx %.02f',mean(gammas(1:2))),...
    sprintf('Health, \\gamma \\approx %.02f',gammas(1)),...
    sprintf('Arts, \\gamma \\approx %.02f',gammas(6)),...
    sprintf('Combined Purpose, \\gamma \\approx %.02f',gammas(4)),...
    sprintf('Reference, \\gamma \\approx %.02f',gamma_ref),...   
    sprintf('Religion, \\gamma \\approx %.02f',gamma_relig)};
gammas = [mean(gammas(1:2)),...
    gammas(1),...
    gammas(6),...
    gammas(4),...
    gamma_ref,...
    gamma_relig];
[gammas,gamma_index] = sort(gammas);
titles = cell(1,6);
for i=1:6    
    titles{i} = titles_tmp{gamma_index(i)};
end
X = linspace(12500,500000,100);
% gammas = [1.79 1.86 2.02 2.26 2.41 3.26];
%% plot it
for i=1:6
    % plot points
    plot(log10(X),(X./25000).^((gammas(i)-2.41)/(1-gammas(i))),'Color',0.5*[1 1 1],'LineWidth',1.75);
    hold on;
    % plot dots
    tmph(i) = plot(log10(income),(income./25000).^((gammas(i)-2.41)/(1-gammas(i))),'Marker',tmpsym{i},'MarkerFaceColor',tmpcol{i},'LineStyle','none');
end

set(gca,'fontsize',15);
set(gca,'color','none');

%% axis([]);
ylim([-1,11]);
xlim(log10([12000 510000]));

%% change axis line width (default is 0.5)
%% set(tmpaxes(axesnum),'linewidth',2)

%% fix up tickmarks
income_dollar_signs = {'$12,500' '$25,000' '$50,000' '$100,000' '$250,000' '$500,000'};
income_dollar_signs = [0.5,1,2,4,10,20];
set(gca,'xtick',log10(income))
%month_names={'J','F','M','A','M','J','J','A','S','O','N','D'};
set(gca,'xticklabel',income_dollar_signs,'fontsize',14)

% set(gca,'ytick',1e6:2e6:2.4e7);
% for i=1:12
%   ylabels{i}=num2str(2*i);
% end
% set(gca,'yticklabel',ylabels,'fontsize',11);

%% legend
tmp1h = legend(tmph,titles,'location','northwest');
% %% tmplh = legend('','','');
%set(tmplh,'position',get(tmplh,'position')-[x y 0 0])
% %% change font
% tmplh = findobj(tmplh,'type','text');
set(tmp1h,'FontSize',15);
% %% remove box:
legend boxoff

%% use latex interpreter for text, sans serif

tmpxlab=xlabel('Giving ratio','fontsize',23,'fontname','helvetica','interpreter','latex','HorizontalAlignment','center');
tmpylab=ylabel('Relative Size of Total Donations','fontsize',23,'fontname','helvetica','interpreter','latex'); %,'VerticalAlignment','middle');

%set(tmpxlab,'position',get(tmpxlab,'position') - [0 100 0]);
set(tmpylab,'position',get(tmpylab,'position') - [0 1.2 0]);

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