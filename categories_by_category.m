clear all;
load ../../data/categories_income_byincome.mat
%% figure('visible','off');

tmpfigh = gcf;
clf;
figshape(1000,750);
%% automatically create postscript whenever
%% figure is drawn
tmpfilename = 'categories_by_category';

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

tmpw1 = 0.35;
tmpw2 = 0.35;
%% tmpw3 = 0.22;

tmph1 = 0.30;

positions(1).box = [tmpx1                    , tmpy2, tmpw1, tmph1];
positions(2).box = [tmpx1 + tmpw1 + tmpxg1 , tmpy2, tmpw2, tmph1];
%positions(3).box = [tmpx1 + tmpw1 + tmpw2 + tmpxg1 + tmpxg2, tmpy2, tmpw2, tmph1];
positions(3).box = [tmpx1                    , tmpy1, tmpw1, tmph1];
positions(4).box = [tmpx1 + tmpw1 +  tmpxg1, tmpy1, tmpw2, tmph1];
%positions(6).box = [tmpx1 + tmpw1 + tmpw2 + tmpxg1 + tmpxg2, tmpy1, ...
%                    tmpw2, tmph1];

tmplabels = {' A ',' B ',' C ',' D '};

tmpxlabelpos = [.38 .32 .31 .40]-.1;
tmpylabelpos = .85*[1 1 1 1];

tmptitles = {'Donor Income $<$\$100K' 'Donor Income in \$100K-\$200K' 'Donor Income in \$200K-\$1M' 'Donor Income $>$\$1M'};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% main data goes here


for i = 1:length(categories_income)
    axesnum = i;
    tmpaxes(axesnum) = axes('position',positions(axesnum).box);
    
    tmpsum = sum(categories_income(i).data);
    tmpdata = categories_income(i).data.*100./tmpsum;
    
    tmph = bar(1:1:length(categories_income(i).data),tmpdata,'FaceColor',[0, 180, 247]/255);
    %set(tmph,'color',0.7*[1 1 1]);
    hold on;
    
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
    xlim([.5 6.5]);

    if (i==4)
        tmpxlab=xlabel('Donation categories', ...
                       'fontsize',20,'verticalalignment','top','fontname','helvetica','interpreter','latex');
        set(tmpxlab,'position',get(tmpxlab,'position') + [-3.5 0 0]);
    end
    if (i==1)
        tmpylab=ylabel('Percentage of total donation dollars','fontsize',20,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');
        set(tmpylab,'position',get(tmpylab,'position') + [.17 -60 0]);
    end


    %% fix up tickmarks
    set(gca,'ytick',[0:20:100]);
    if i==1
        set(gca,'yticklabel',[0:20:100],'fontsize',13);
    else if i==3
            set(gca,'yticklabel',[0:20:100],'fontsize',13);
        else
            set(gca,'yticklabel',[]);
        end
    end
    
    set(gca,'xticklabel',[])
    if i>2
        set(gca,'xticklabel',{'Religion' 'Arts' 'Education' 'Health' 'CP Funds' 'Other'},'fontsize',13)
    end
    



    %% use latex interpreter for text, sans serif

    tmpXcoord = tmpxlabelpos(i);

    tmpYcoord = tmpylabelpos(i);
    tmpstr = tmptitles{i};


    addlabel3(tmplabels{i},tmpXcoord-0.08,tmpYcoord,14);
    text(tmpXcoord,tmpYcoord,tmpstr,...
         'fontsize',16,...
         'fontname','helvetica',...
         'units','normalized',...
         'interpreter','latex');


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

end


%% automatic creation of postscript
%% without name/date
psprintcpdf_keeppostscript(tmpfilenoname);

%% name label
%% tmpt = pwd;
%% tmpnamememo = sprintf('[source=%s/%s.ps]',tmpt,tmpfilename);

% [tmpXcoord,tmpYcoord] = normfigcoords(1.05,.05);
% text(tmpXcoord,tmpYcoord,tmpnamememo,...
%      'units','normalized',...
%      'fontsize',2,...
%      'rotation',90,'color',0.8*[1 1 1]);

%[tmpXcoord,tmpYcoord] = normfigcoords(1.1,.05);
%datenamer(tmpXcoord,tmpYcoord,90);

%% automatic creation of postscript
%% psprintcpdf(tmpfilename);

tmpcommand = sprintf('open %s.pdf;',tmpfilenoname);
system(tmpcommand);

%% archivify
%figurearchivify(tmpfilenoname);

close(tmpfigh);
clear all