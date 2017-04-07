clear all

smallaxislabelsize = 14;
insetlabelsize = 26;
labelsize=30;
smallaxistitlesize = 19;
%% figure('visible','off');

%% set(gcf,'color','none');
tmpfigh = gcf;
clf;
% figshape(2600,800); %for 3 side by side
figshape(800,1100); %for big on top, two small below
% automatically create postscript whenever
% figure is drawn
tmpfilename = 'mechanism001';

tmpfilenoname = sprintf('%s_noname',tmpfilename);

%% global switches

set(gcf,'Color','none');
set(gcf,'InvertHardCopy', 'off');

set(gcf,'DefaultAxesFontname','helvetica');
set(gcf,'DefaultLineColor','r');
set(gcf,'DefaultAxesColor','none');
set(gcf,'DefaultLineMarkerSize',15);
set(gcf,'DefaultLineMarkerEdgeColor','k');
set(gcf,'DefaultLineMarkerFaceColor','g');
set(gcf,'DefaultAxesLineWidth',0.5);
set(gcf,'PaperPositionMode','auto');

tmpsym = {'o','s','v','o','s','v'};
tmpcol = {'g','b','r','k','c','m'};

tmpxleftspace = .15;
tmpxspace = .07;
tmpxwidth = .22;
height = 0.5;

% for side by side
% for sam=1:3
%     positions(sam).box = [tmpxleftspace+(sam-1)*tmpxwidth+(sam-1)*tmpxspace .2 tmpxwidth height]; % [left bottom width height]
% end

% for one big on top, two small below
positions(1).box = [.1 .45 .80 .53]; % [left bottom width height]

positions(2).box = [.1 .1 .365 .25];
positions(3).box = [.535 .1 .365 .25];

for i=1:3
    
    axesnum = i;
    tmpaxes(axesnum) = axes('position',positions(axesnum).box);
    
    % make a plot for each of the five lines, not using log space but faking it
    
    % set the offsets
    offset = [0 .2 .7 1.0 1.2 1.35];
    % set the linestyles
    linestyles = {'k' 'b--' 'r--' 'g--' 'c--' 'm--'};
    for j=1:6
        plot([0 4],[6 2]-offset(j),linestyles{j});
        hold on;
    end
    
    set(gca,'fontsize',16);
    
    % % legend
    % tmp1h = legend(tmph,sprintf('%s, %d',name1,year1),sprintf('%s, %d',name2,year2),'Location',[.61,.81,.15,.072]); % [left,bottom,width,height]
    % %set(tmp1h,'position',get(tmp1h,'position')-[0 0 0 0]) %% -[x y 0 0]
    % %% change font
    % %tmplh = findobj(tmplh,'type','text');
    % set(tmp1h,'FontSize',14);
    % %% remove box:
    % legend boxoff
    
    
    %% plot some extra lines
    if i==1
        plot([2.5 2.5],[1.5 4.8],'Color',0.7*[1 1 1]);
        
        %  x(1),y(1) to the point defined by x(2),y(2), specified in normalized figure units
        annotation('textarrow', [.168 .6]+[.01 0], [.712 .74]+[.02 0],'fontsize',15,'Color',[0.01 0.01 0.01]);
        annotation('textarrow', [.226 .6]+[.01 0], [.64 .70]+[.02 0], 'String', '','fontsize',15,'Color',0.01*[1 1 1]);
        annotation('textarrow', [.267 .6]+[.01 0], [.598 .67]+[.02 0], 'String', '','fontsize',15,'Color',0.01*[1 1 1]);
        annotation('textarrow', [.293 .6]+[.01 0], [.568 .655]+[.02 0], 'String', '','fontsize',15,'Color',0.01*[1 1 1]);
        annotation('textarrow', [.312 .6]+[.01 0], [.544 .64]+[.02 0], 'String', '','fontsize',15,'Color',0.01*[1 1 1]);
    end
    
    if i==2
        plot([0 4],[6-offset(2) 2-offset(6)],'k')
    end
    
	if i==3
        plot([0 4],[6-offset(6) 2-offset(2)],'k')
    end
    
    %% label stuff correctly

    if i==1
        
        tmpylab=ylabel('$\log_{10}$ Gift size $S$','fontsize',labelsize,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');
        set(tmpylab,'position',get(tmpylab,'position') + [-.05 0 0]);
        
        tmpxlab=xlabel('$\log_{10}$ Donor rank $d$','fontsize',labelsize,'verticalalignment','top','fontname','helvetica','interpreter','latex');
        set(tmpxlab,'position',get(tmpxlab,'position') - [0 .1 0]);
        
        addlabel3(' A ',.85,.86,labelsize);
    end
    if i==2
        tmpylab=ylabel('$\log_{10}$ Gift size $S$','fontsize',labelsize,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');
        set(tmpylab,'position',get(tmpylab,'position') + [-.05 0 0]);
        
        tmpxlab=xlabel('$\log_{10}$ Gift rank $r$','fontsize',labelsize,'verticalalignment','top','fontname','helvetica','interpreter','latex');
        set(tmpxlab,'position',get(tmpxlab,'position') + [2.5 -.1 0]);
        
        addlabel3(' B ',.08,.18,labelsize);
    end
    
    if i==3
        set(gca,'yticklabel',[],'fontsize',11);
        set(gca,'yticklabel',[],'fontsize',15);
        addlabel3(' C ',.08,.18,labelsize);
    end
end


tmpaxes(4) = axes('position',positions(1).box+[0.08 0.10 -.6 -.33]);  % [left bottom width height]
plot(log10((1:5)),log10(800.*(1:5).^(-1/1.5)),'.');
ylim([2.4,2.95]);
set(gca,'yticklabel',1:6,'fontsize',smallaxislabelsize);
set(gca,'xticklabel',[0 0.5 1 1.5 2.0],'fontsize',smallaxislabelsize);
tmpylab=ylabel('$\log_{\,\,\,10}$ Gift Size','fontsize',smallaxistitlesize,'verticalalignment','bottom','fontname','helvetica','interpreter','latex'); %
set(tmpylab,'position',get(tmpylab,'position') - [0.009 0 0]);

tmpxlab=xlabel('Single Donor','fontsize',insetlabelsize,'verticalalignment','bottom','fontname','helvetica','interpreter','latex'); %
xpos = get(tmpxlab,'position') + [.00 .00 .00];
set(tmpxlab,'position',get(tmpxlab,'position') + [-.00 -.16 0]);
disp(get(tmpxlab,'position'))

small_x_label = text(0.07,2.294,'$\log_{\,\,\,10}$ Gift Rank','fontsize',smallaxistitlesize,'fontname','helvetica','interpreter','latex');

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
