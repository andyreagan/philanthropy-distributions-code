% notes:
% 
% adding overlay of transforming ratio, need to use data to compare apples
%   to apples. from the model, want to get an estimate for the whole bin

% 6-3-13
% i think I've made a mistake in the past here: I renormalized the columns
%   to that they added to 100%
%   but that shouldn't be the case, we're not actually looking what that
%   would imply (not looking at where religion's money comes from, but
%   rather how much people of different income groups give to religion)

clear all;
load ../../data/categories_income_bycategory.mat
%% figure('visible','off');

tmpfigh = gcf;
clf;
figshape(1000,750);
%% automatically create postscript whenever
%% figure is drawn
tmpfilename = 'categories_by_income';

tmpfilenoname = sprintf('%s_noname',tmpfilename);

%% global switches

%% set(gcf,'Color','none');
%% set(gcf,'InvertHardCopy', 'off');

set(gcf,'DefaultAxesFontname','helvetica');

set(gcf,'DefaultAxesColor','none');
set(gcf,'DefaultLineMarkerSize',2);
set(gcf,'DefaultLineMarkerEdgeColor','k');
set(gcf,'DefaultLineMarkerFaceColor',0.5*[1 1 1]);
set(gcf,'DefaultAxesLineWidth',0.5);
set(gcf,'DefaultLineMarkerSize',8);

set(gcf,'PaperPositionMode','auto');

%% tmpsym = {'k.','r.','b.','m.','c.','g.','y.'};
%% tmpsym = {'ok-','sk-','dk-','vk-','^k-','>k-','<k-','pk-','hk-'};
tmpsym = {'ok','sk','dk','vk','^k','>k','<k','pk','hk'};
%% tmpsym = {'ok-','sr-','db-','vm-','^c-','>g-','<k-','pk-','hk-'};
%% tmpsym = {'k-','k-.','k:','k--','r-','r-.','r:','r--'};
%% tmplw = [ 1.5*ones(1,4), .5*ones(1,4)];


%%%%%%%%%%%%%%%%%%%
tmpx1 = 0.15;
tmpy1 = 0.20;
tmpy2 = 0.56;

tmpxg1 = 0.02;
tmpxg2 = 0.02;
%% tmpxg3 = 0.04;

tmpyg1 = 0.05;

tmpw1 = 0.20;
tmpw2 = 0.20;
%% tmpw3 = 0.22;

tmph1 = 0.30;

positions(1).box = [tmpx1                    , tmpy2, tmpw1, tmph1];
positions(2).box = [tmpx1 + tmpw1 + tmpxg1 , tmpy2, tmpw2, tmph1];
positions(3).box = [tmpx1 + tmpw1 + tmpw2 + tmpxg1 + tmpxg2, tmpy2, tmpw2, tmph1];
positions(4).box = [tmpx1                    , tmpy1, tmpw1, tmph1];
positions(5).box = [tmpx1 + tmpw1 +  tmpxg1, tmpy1, tmpw2, tmph1];
positions(6).box = [tmpx1 + tmpw1 + tmpw2 + tmpxg1 + tmpxg2, tmpy1, ...
                    tmpw2, tmph1];

tmplabels = {' A ',' B ',' C ',' D ',' E ',' F '};

tmpxlabelpos = [.35 .38 .30 .32 .21 .35]+.1;
tmpylabelpos = .89*[1 1 1 1 1 1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% main data goes here

% calculated data from Bill
% if I could get an expression for these calculations, maybe I could make
%   the lines smoother

computed_data = [75.00	43.89	30.53	13.54;...
    3.20	5.41	7.73	17.15;...
    2.00	5.41	10.62	48.10;...
    2.00	4.48	7.75	26.36;...
    8.00	8.08	8.14	8.26;...
    0 0 0 0];
%% new with ML gammas
computed_data = [63.60 48.87 40.88 27.41;...
    2.98 4.53 6.01 11.34;...
    2.04 5.86 11.97 59.38;...
    3.45 5.95 8.60 19.66;...
    9.27 8.75 8.41 7.70;...
    0 0 0 0];
%%
load ../../data/taxdata_raw.mat
tmp2 = [0;tmp(:,1)];
bin_counts = zeros(length(tmp(:,1)),1);
bin_total_gifts = bin_counts;
for i=1:length(bin_counts)
    bin_counts(i) = tmp2(i+1)-tmp2(i);
    bin_total_gifts(i) = bin_counts(i)*tmp(i,4);
end

small_bin_count = [sum(bin_counts(1:5));sum(bin_counts(6:7));sum(bin_counts(8));sum(bin_counts(9:end))];
small_bin_gifts = [sum(bin_total_gifts(1:5));sum(bin_total_gifts(6:7));sum(bin_total_gifts(8));sum(bin_total_gifts(9:end))];
small_bin_av_gift = zeros(4,1);
for i=1:4
    small_bin_av_gift(i) = small_bin_gifts(i)/small_bin_count(i);
end

gamma_ref = csvread('tax_return_gifts_gamma.csv');
gamma_relig = csvread('relig_inst_corrected_gamma.csv');

gammas_all = csvread('inst_gamma_MLE.csv');
%disp(gammas_all);
gammas = [mean(gammas_all(1:2,1)),...
    mean(gammas_all(1:5,2)),...
    mean(gammas_all(1:5,3)),...
    mean(gammas_all(3:7,4)),...
    mean(gammas_all(1:5,5)),...
    mean(gammas_all(1:5,6))];
%disp(gammas);
gamma_edu = mean(gammas(1:2));
gamma_health = gammas(1);
gamma_arts = gammas(6);
gamma_cp = gammas(4);

gammas_new = [gamma_relig;gamma_arts;gamma_edu;gamma_health;gamma_cp];
computed_data = zeros(6,4);
for donation_category=1:5
    gamma = gammas_new(donation_category);
    donation_total = sum(fliplr(categories_income(donation_category).data)'./100.*small_bin_gifts);
    % disp(donation_total)
    bin1_f = donation_total/sum((fliplr(small_bin_av_gift')./small_bin_av_gift(4)).^((gamma-gamma_ref)/(1-gamma)).*fliplr(small_bin_gifts'));
    disp(bin1_f)
    fprintf('across data\n');
    disp(bin1_f.*((fliplr(small_bin_av_gift')./small_bin_av_gift(4)).^((gamma-gamma_ref)/(1-gamma))).*100)
    computed_data(donation_category,:) = bin1_f.*((fliplr(small_bin_av_gift')./small_bin_av_gift(4)).^((gamma-gamma_ref)/(1-gamma))).*100;
end

disp(computed_data)

%%
% fix this up (get the "other" category correct)
for i=1:length(computed_data(1,:))
    computed_data(end,i) = 100 - sum(computed_data(:,i));
end

for i = 1:length(categories_income)
    axesnum = i;
    tmpaxes(axesnum) = axes('position',positions(axesnum).box);
    
    % here is the renormalization step, that I'm going to delete
    %tmpsum = sum(categories_income(i).data);
    %tmpdata = categories_income(i).data.*100./tmpsum;
    % now just loading in the data
    tmpdata = categories_income(i).data;
    
    tmph = bar(1:1:length(categories_income(i).data),tmpdata,'FaceColor',[0, 180, 247]/255);
    %set(tmph,'color',0.7*[1 1 1]);
    hold on;
    
    if i<6
        plot(1:4,computed_data(i,:),'Color',[255, 104, 31]/255,'LineWidth',3)
        plot(1:4,computed_data(i,:),'Marker','s','MarkerFaceColor',[255, 104, 31]/255,'LineStyle','none')
    end
    %set(tmph,'markerfacecolor',0.7*[0 1 1]);
    %end

    %set(gca,'fontsize',12);
    %set(gca,'color','none');

    %% for use with layered plots
    %% set(gca,'box','off')

    %% adjust limits
    %% tmpv = axis;
    %% axis([]);

    ylim([0 100]);
    xlim([.5 4.5]);

    if (i==5)
        tmpxlab=xlabel('Donor income groups, in Thousands of Dollars', ...
                       'fontsize',20,'verticalalignment','top','fontname','helvetica','interpreter','latex');
        set(tmpxlab,'position',get(tmpxlab,'position') + [0 2.5 0]);
    end
    if (i==4)
        tmpylab=ylabel('Percentage of total donation dollars','fontsize',20,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');
        set(tmpylab,'position',[-.05 100 0]);
    end


    %% fix up tickmarks
    set(gca,'ytick',[0:20:100]);
    if i==1
        set(gca,'yticklabel',[0:20:100],'fontsize',13);
    else if i==4
            set(gca,'yticklabel',[0:20:100],'fontsize',13);
        else
            set(gca,'yticklabel',[],'fontsize',13);
        end
    end
    
    if i>3
        set(gca,'xticklabel',{'<100' '100-200' '200-1,000' '>1,000'},'fontsize',12)
        xticklabel_rotate([],30,[]);%,'Fontsize',12);        
    else
        set(gca,'xticklabel',[]);
    end
    
    
    %% label (A, B, ...)
    %% addlabel2(tmplabels{i},0.03,0.06,14);


    %% change axis line width (default is 0.5)
    %% set(tmpaxes(axesnum),'linewidth',2)




    %% use latex interpreter for text, sans serif

    %% set 'units' to 'data' for placement based on data points
    %% set 'units' to 'normalized' for relative placement within axes
    tmpXcoord = tmpxlabelpos(i);
    %%    if (i==1)
    %%        tmpXcoord = 0.2;
    %%    end
    tmpYcoord = tmpylabelpos(i);
    tmpstr = {sprintf('%s',categories_income(i).title)};

    if i==5
        tmpstr{1} = 'Combined'; tmpstr{2} = 'Purpose Funds';
    end
    
    addlabel3(tmplabels{i},tmpXcoord-0.12,tmpYcoord,14);
    text(tmpXcoord,tmpYcoord,tmpstr,...
         'fontsize',14,...
         'fontname','helvetica',...
         'units','normalized',...
         'interpreter','latex');

end


%% automatic creation of postscript
%% without name/date
psprintcpdf_keeppostscript(tmpfilenoname);

%% automatic creation of postscript
%% psprintcpdf(tmpfilename);

tmpcommand = sprintf('open %s.pdf;',tmpfilenoname);
system(tmpcommand);

%% archivify
%figurearchivify(tmpfilenoname);

close(tmpfigh);
clear all