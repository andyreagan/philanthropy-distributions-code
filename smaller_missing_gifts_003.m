clear all

plotlogspace = 1;

figure('visible','off');
set(gcf,'color','none');
tmpfigh = gcf;
clf;
figshape(500,250);
%% automatically create postscript whenever
%% figure is drawn
tmpfilename = 'multiple_gifts003';

tmpfilenoname = sprintf('%s_noname',tmpfilename);

%% global switches

set(gcf,'Color','none');
set(gcf,'InvertHardCopy','off');

set(gcf,'DefaultAxesFontname','helvetica');
set(gcf,'DefaultLineColor','r');
set(gcf,'DefaultAxesColor','none');
set(gcf,'DefaultLineMarkerSize',1.2);
set(gcf,'DefaultLineMarkerEdgeColor','k');
set(gcf,'DefaultLineMarkerFaceColor','g');
set(gcf,'DefaultAxesLineWidth',0.5);
set(gcf,'PaperPositionMode','auto');

tmpsym = {'o','s','v','o','s','v'};
tmpcol = {'g','b','r','k','c','m'};

% positions(1).box = [.2 .2 .7 .5];
% axesnum = 1;
% tmpaxes(axesnum) = axes('position',positions(axesnum).box);

%%%%%%%%%%%%%%%%%%%
tmpx1 = 0.15;
tmpy1 = 0.20;
tmpy2 = 0.20;

tmpxg1 = 0.02;
tmpxg2 = 0.02;
%% tmpxg3 = 0.04;

tmpyg1 = 0.05;

tmpw1 = 0.20;
tmpw2 = 0.20;
%% tmpw3 = 0.22;

tmph1 = 0.50;

positions(1).box = [tmpx1                    , tmpy2, tmpw1, tmph1];
positions(2).box = [tmpx1 + tmpw1 + tmpxg1 , tmpy2, tmpw2, tmph1];
positions(3).box = [tmpx1 + tmpw1 + tmpw2 + tmpxg1 + tmpxg2, tmpy2, tmpw2, tmph1];
%positions(4).box = [tmpx1                    , tmpy1, tmpw1, tmph1];
%positions(5).box = [tmpx1 + tmpw1 +  tmpxg1, tmpy1, tmpw2, tmph1];
%positions(6).box = [tmpx1 + tmpw1 + tmpw2 + tmpxg1 + tmpxg2, tmpy1, ...
%    tmpw2, tmph1];




%% main data goes here

for i = 1:3
    axesnum = i;
    tmpaxes(axesnum) = axes('position',positions(axesnum).box);
    
    
    set(gca,'fontsize',11);
    set(gca,'color','none');
    
    powerlabelsize = 6;
    pointersize = 6;
    figuresize = 6;
    labelsize = 9;
    legendsize = 6;
    
    % first plot, extra donations
    if i==1
        
        %% make artificial data
        c=10000; % biggest gift
        N=1775; % number of gifts following power law
        N2=2000; % total number of gifts
        alpha=0.65; % corresponding to gamma=2.52
        
        donors = 1:N2;
        gifts = zeros(1,N2);
        % power law region
        for j=1:N
            gifts(j)=c.*(j).^(-alpha);
        end
        % cutoff
        for j=N+1:N2
            gifts(j)=c.*(N).^(-alpha).*((N2-j)./(N2-N));
        end
        
        % plot the reference distribution
        line = plot(log10(donors),log10(gifts),'Color',0.7*[1 1 1]);
        hold on;
        if plotlogspace
            pts2plot=floor(logspace(0,log10(N2),75));
        else
            pts2plot=1:N2;
        end
  
        tmph(1) = plot(log10(donors(pts2plot)),log10(gifts(pts2plot)),'Marker',tmpsym{1},'MarkerEdgeColor',tmpcol{1},'MarkerFaceColor',tmpcol{1},'LineStyle','none');
        
        
        %% plot the double gifts
        gifts = [.7.*gifts .25.*gifts .05.*gifts];
        gifts=sort(gifts,'descend');
        
        line = plot(log10(1:length(gifts)),log10(gifts),'Color',0.7*[1 1 1]);
        hold on;
        
        plotlogspace =1;
        if plotlogspace
            pts2plot=floor(logspace(0,log10(length(gifts)),75));
        else
            pts2plot=1:length(gifts);
        end
        
        tmph(2) = plot(log10(pts2plot),log10(gifts(pts2plot)),'Marker',tmpsym{2},'MarkerEdgeColor',tmpcol{2},'MarkerFaceColor',tmpcol{2},'LineStyle','none');
        set(gca,'fontsize',11);
        %tmpylab=ylabel('$\log _{\,10}$ Donations $d$','fontsize',10,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');
        
        %% legend
        tmp1h = legend(tmph,'Reference','Comparison');
        set(tmp1h,'FontSize',6);
        set(tmp1h,'position',get(tmp1h,'position')+[0.02 0.00 0 0])
        legend boxoff;
        
        N = findobj(tmp1h,'type','text');
        set(N(1),'position',get(N(1),'position') - [.15,0,0]);
        set(N(2),'position',get(N(2),'position') - [.15,0,0]);
        
        %%
        
        %tmpxlab=xlabel('$\log_{\,\,10}$ Gift rank $r$','fontsize',labelsize,'verticalalignment','top','fontname','helvetica','interpreter','latex');
        tmpylab=ylabel('$\log_{\,\,10}$ Gift size $S$','fontsize',labelsize,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');
        
        %%
        
        X=.09; Y = X;
        addlabel3(' A ',X,Y,8);
        %set(gca,'yticklabel',[]);
        set(gca,'ytick',1:6);
        set(gca,'yticklabel',1:6);
    end
    
    % second plot, relig with incorrect data
    if i==2
        
        % basics
        load ../../data/inst_x.mat
        
        %% load and clean real data
        donations = inst_x.data(:,3);
        if (min(donations==0))
            donations = donations(1:min(find(donations==0))-1);
        end
        
        %% make artificial data
        c=100000; % biggest gift
        N=1875; % number of gifts following power law
        N2=2000; % total number of gifts
        alpha=0.99; % corresponding to gamma=2.52
        
        donors = 1:N2;
        gifts = zeros(1,N2);
        for j=1:N
            gifts(j)=c.*(j).^(-alpha);
        end
        for j=N+1:N2
            gifts(j)=c.*(N).^(-alpha).*((N2-j)./(N2-N));
        end
        %% plot the areas
        
        X=log10([donors(1500:1999),fliplr(1000:length(donations))]);                %create continuous x value array for plotting
        Y=log10([gifts(1500:1999),fliplr(donations(1000:end)')]);   %create y values for out and then back
        fill(X,Y,[153 204 255]/255);
        b = annotation('textarrow', [.23 .27]+.26, [.59 .59]-.33, 'String' , 'Repeats ','fontsize',pointersize,'Color',0.01*[1 1 1],'HeadWidth',5,'HeadLength',5);
        hold on;
        
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
            
            tmph(j) = plot(log10(1:N),log10(donations),'Marker',tmpsym{j},'MarkerFaceColor',tmpcol{j},'LineStyle','none');
            % 'Color', [0.5, 1.0, 0.0], 'LineStyle', '--'
        end
        
        set(gca,'fontsize',figuresize);
        
        %% legend
        tmp1h = legend(tmph,label);%,'Location',[.54,.79,.15,.072]); % [left,bottom,width,height]
        set(tmp1h,'FontSize',legendsize);
        set(tmp1h,'position',get(tmp1h,'position')+[0.02 0.00 0 0])
        legend boxoff
        
        N = findobj(tmp1h,'type','text');
        for j=1:length(label)
            set(N(j),'position',get(N(j),'position') - [.15,0,0]);
        end
        
        %% plot the fitted gamma, and label it
         offset=0.25;
        fitregion=8:110;
        [alpha,gamma]=plotpowerfit(fitregion,donations(fitregion),8,110,offset);
        
        clear tmptxt
        
        tmptxt{1} =sprintf('\\alpha = %1.2f',alpha);
        tmptxt{2} =sprintf('\\gamma = %1.2f',gamma);
        text(.295,.675,tmptxt,...
            'fontsize',powerlabelsize,...
            'fontname','helvetica',...
            'units','normalized',...
            'interpreter','tex');
        
        
        offset=0.25;
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
        
        X=.09; Y = X;
        addlabel3(' B ',X,Y,8);
        set(gca,'ytick',1:6);
        %set(gca,'yticklabel',1:6);
        set(gca,'yticklabel',[]);
        
        tmpxlab=xlabel('$\log_{\,\,10}$ Gift rank $r$','fontsize',labelsize,'verticalalignment','top','fontname','helvetica','interpreter','latex');
        
    end
    
    % third plot, missing donations
    if i==3
        
        % basics
        load ../../data/inst_x_cor.mat
        powerlabelsize = 6;
        pointersize = 6;
        figuresize = 6;
        labelsize = 9;
        legendsize = 6;
        
        %% plot the actual data
        for j=[1 2 3]
            year = inst_x_cor.years(j);
            donations = inst_x_cor.data(:,j);
            if (min(donations==0))
                donations = donations(1:min(find(donations==0))-1);
            end
            N = length(donations);
            
            label{j}=num2str(year);
            
            line = plot(log10(1:N),log10(donations),'Color',0.7*[1 1 1]);
            hold on;
            tmph(j) = plot(log10(1:N),log10(donations),'Marker',tmpsym{j},'MarkerFaceColor',tmpcol{j},'LineStyle','none');
            % 'Color', [0.5, 1.0, 0.0], 'LineStyle', '--'
        end
        
        set(gca,'fontsize',figuresize);
        
        %% legend
        tmp1h = legend(tmph,label);%,'Location',[.54,.79,.15,.072]); % [left,bottom,width,height]
        %set(tmp1h,'position',get(tmp1h,'position')-[0.05 0.05 0 0]) %% -[x y 0 0]
        set(tmp1h,'FontSize',legendsize);
        set(tmp1h,'position',get(tmp1h,'position')+[0.02 0.00 0 0])
        
        legend boxoff
        
        
        N = findobj(tmp1h,'type','text');
        for j=1:length(label)
            set(N(j),'position',get(N(j),'position') - [.15,0,0]);
        end
        
        %% plot the fitted gamma, and label it
        year = inst_x_cor.years(2);
        donations = inst_x_cor.data(:,2);
        if (min(donations==0))
            donations = donations(1:min(find(donations==0))-1);
        end
        offset=0.35;
        fitregionlow=8;
        fitregionhigh=200;
        [alpha,gamma]=plotpowerfit(fitregionlow:fitregionhigh,donations(fitregionlow:fitregionhigh),fitregionlow,fitregionhigh,offset);
        
        clear tmptxt
        
        tmptxt{1} =sprintf('\\alpha = %1.2f',alpha);
        tmptxt{2} =sprintf('\\gamma = %1.2f',gamma);
        text(.65,.53,tmptxt,...
            'fontsize',powerlabelsize,...
            'fontname','helvetica',...
            'units','normalized',...
            'interpreter','tex');
        
        X=.09; Y = X;
        addlabel3(' C ',X,Y,8);
        set(gca,'ytick',1:6);
        set(gca,'yticklabel',[]);
    end
    
    set(gca,'fontsize',6);
    
    
    %% for use with layered plots
    %% set(gca,'box','off')
    
    %% adjust limits
    %% tmpv = axis;
    %% axis([]);
    
    ylim([0.2,6]);
    xlim([0,4]);
    
    %% change axis line width (default is 0.5)
    %% set(tmpaxes(axesnum),'linewidth',2)
    
    %% fix up tickmarks
    set(gca,'xtick',0:4)
    %set(gca,'xticklabel',ylabels);
    %month_names={'J','F','M','A','M','J','J','A','S','O','N','D'};
    %set(gca,'xticklabel','fontsize',6)
    
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
    
    
    
    %% use latex interpreter for text, sans serif
    
    %set(tmpxlab,'position',get(tmpxlab,'position') - [0 .1 0]);
    %% set(tmpylab,'position',get(tmpylab,'position') - [.1 0 0]);
    
end

%% automatic creation of postscript
% without name/date
psprintcpdf(tmpfilenoname);
% keep postscript for publication
% psprintcpdf_keeppostscript(tmpfilenoname);

% automatic creation of postscript
% psprintcpdf(tmpfilename);

tmpcommand = sprintf('open %s.pdf;',tmpfilenoname);
system(tmpcommand);

% archivify
figurearchivify(tmpfilenoname);

close(tmpfigh);
clear all