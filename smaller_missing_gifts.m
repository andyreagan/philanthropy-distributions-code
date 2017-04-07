clear all

%% uses ../data/UVM_accumulation.mat

plotlogspace = 1;

figure('visible','off');
set(gcf,'color','none');
tmpfigh = gcf;
clf;
figshape(500,500);
%% automatically create postscript whenever
%% figure is drawn
tmpfilename = 'multiple_gifts';

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
tmpcol = {[0 153 0]/255,[0 128 255]/255,[255 51 51]/255,'k','c','m'};

% positions(1).box = [.2 .2 .7 .5];
% axesnum = 1;
% tmpaxes(axesnum) = axes('position',positions(axesnum).box);

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

tmph1 = 0.25;

positions(1).box = [tmpx1                    , tmpy2, tmpw1, tmph1];
positions(2).box = [tmpx1 + tmpw1 + tmpxg1 , tmpy2, tmpw2, tmph1];
positions(3).box = [tmpx1 + tmpw1 + tmpw2 + tmpxg1 + tmpxg2, tmpy2, tmpw2, tmph1];
positions(4).box = [tmpx1                    , tmpy1, tmpw1, tmph1];
positions(5).box = [tmpx1 + tmpw1 +  tmpxg1, tmpy1, tmpw2, tmph1];
positions(6).box = [tmpx1 + tmpw1 + tmpw2 + tmpxg1 + tmpxg2, tmpy1, ...
    tmpw2, tmph1];




%% main data goes here

% make artificial data
c=10000; % biggest gift
N=1875; % number of gifts following power law
N2=5000; % total number of gifts
alpha=0.65; % corresponding to gamma=2.52

donors = 1:N2;
gifts = zeros(1,N2);
for i=1:N
    gifts(i)=c.*(i).^(-alpha);
end
for i=N+1:N2
    gifts(i)=c.*(N).^(-alpha).*((N2-i)./(N2-N));
end

for i = 1:3
    
    
    
    axesnum = i;
    tmpaxes(axesnum) = axes('position',positions(axesnum).box);
    
    % plot the reference distribution
    line = plot(log10(donors),log10(gifts),'Color',0.7*[1 1 1]);
    hold on;
    
    if plotlogspace
        pts2plot=floor(logspace(0,log10(N2),75));
    else
        pts2plot=1:N2;
    end
    
    
    tmph(1) = plot(log10(donors(pts2plot)),log10(gifts(pts2plot)),'Marker',tmpsym{1},'MarkerEdgeColor',tmpcol{1},'MarkerFaceColor',tmpcol{1},'LineStyle','none');
    set(gca,'fontsize',11);
    set(gca,'color','none');
    % first plot, multiple gifts
    if i==1
        
        
        % now we'll split the gifts into 1/4 and 3/4
        % there will be twice as many gifts
        N2=2*N2;
        tmp_gifts = .25.*gifts; % the smaller parts
        tmp2_gifts = .75.*gifts; % the bigger parts
        donors = 1:N2;
        gifts = zeros(1,N2);
        for i=1:N2/2
            gifts(i)=tmp_gifts(i);
            gifts(i+N2/2)=tmp2_gifts(i);
        end
        gifts=sort(gifts,'descend');
        
        line = plot(log10(donors),log10(gifts),'Color',0.7*[1 1 1]);
        hold on;
        
        if plotlogspace
            pts2plot=floor(logspace(0,log10(N2),75));
        else
            pts2plot=1:N2;
        end
        
        tmph(2) = plot(log10(donors(pts2plot)),log10(gifts(pts2plot)),'Marker',tmpsym{2},'MarkerEdgeColor',tmpcol{2},'MarkerFaceColor',tmpcol{2},'LineStyle','none');
        set(gca,'fontsize',11);
        tmpylab=ylabel('$\log _{\,10}$ Donations $d$','fontsize',10,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');
        
        %% legend
        tmp1h = legend(tmph,'Comparison','Reference');
        %% tmplh = legend('','','');
        set(tmp1h,'FontSize',6);
        
        set(tmp1h,'position',[.24 .755 .13 .05 ]);
        %% change font
        
        %% remove box:
        legend boxoff
        
        N = findobj(tmp1h,'type','text');
        pos = get(N,'Position');
        set(N(1),'Position',[.31,.75,0]);
        set(N(2),'Position',[.31,.32,0]);
        
        X=.09; Y = X;
        addlabel3(' A ',X,Y,8);
    end
    
    
    
    % second plot, smaller donations
    if i==2
        log_exponential_mean = 100;
        log_exponential_stddev = 3;
        for k=1:length(gifts)
            missing_donors(k) = exp(-2*((log10(k)-log10(log_exponential_mean))/(log10(log_exponential_stddev)))^2);
            tmp_gifts(k)=(1-missing_donors(k))*gifts(k);
        end
        tmp_gifts=sort(tmp_gifts,'descend');
        
        if plotlogspace
            pts2plot=floor(logspace(0,log10(N2),75));
        else
            pts2plot=1:N2;
        end
        
        line = plot(log10(donors),log10(tmp_gifts),'Color',0.7*[1 1 1]);
        tmph(2) = plot(log10(donors(pts2plot)),log10(tmp_gifts(pts2plot)),'Marker',tmpsym{2},'MarkerEdgeColor',tmpcol{2},'MarkerFaceColor',tmpcol{2},'LineStyle','none');
        set(gca,'fontsize',11);
        line = plot(log10(donors),log10(25.*missing_donors),'Color',0.7*[1 1 1]);
        tmph(3) = plot(log10(donors(pts2plot)),log10(25.*missing_donors(pts2plot)),'Marker',tmpsym{3},'MarkerEdgeColor',tmpcol{3},'MarkerFaceColor',tmpcol{3},'LineStyle','none');
        
        tmpxlab=xlabel('$\log _{\,10}$ Rank $r$','fontsize',10,'verticalalignment','top','fontname','helvetica','interpreter','latex');
        set(gca,'yticklabel',[])
        
        %% legend
        tmp1h = legend(tmph,'Affected Donors','Comparison','Reference');
        set(tmp1h,'fontSize',6);
        set(tmp1h,'position',get(tmp1h,'position')+[.03 .01 0 0 ]); %[-.2 -0.089 .15 .15])
        %% move text around
        N = findobj(tmp1h,'type','text');
        pos = get(N,'Position');
        set(N(1),'Position',[.27,.80,0]);
        set(N(2),'Position',[.27,.50,0]);
        set(N(3),'Position',[.27,.2,0]);
        %% remove box:
        legend boxoff
        
        addlabel3(' B ',X,Y,8);
    end
    
    
    
    % third plot, missing donations
    if i==3
        log_exponential_mean = 100;
        log_exponential_stddev = 3;
        for k=1:length(gifts)
            missing_donors(k) = exp(-2*((log10(k)-log10(log_exponential_mean))/(log10(log_exponential_stddev)))^2);
            tmp_gifts(k)=(1-0.5*missing_donors(k))*gifts(k);
        end
        tmp_gifts=sort(tmp_gifts,'descend');
        
        if plotlogspace
            pts2plot=floor(logspace(0,log10(N2),75));
        else
            pts2plot=1:N2;
        end
        
        line = plot(log10(donors),log10(tmp_gifts),'Color',0.7*[1 1 1]);
        tmph(2) = plot(log10(donors(pts2plot)),log10(tmp_gifts(pts2plot)),'Marker',tmpsym{2},'MarkerEdgeColor',tmpcol{2},'MarkerFaceColor',tmpcol{2},'LineStyle','none');
        
        line = plot(log10(donors),log10(25.*missing_donors),'Color',0.7*[1 1 1]);
        tmph(3) = plot(log10(donors(pts2plot)),log10(25.*missing_donors(pts2plot)),'Marker',tmpsym{3},'MarkerEdgeColor',tmpcol{3},'MarkerFaceColor',tmpcol{3},'LineStyle','none');
        
        set(gca,'yticklabel',[])
        
        %% legend
        tmp1h = legend(tmph,'Affected Donors','Comparison','Reference');
        set(tmp1h,'FontSize',6);
        set(tmp1h,'position',get(tmp1h,'position')+[.03 .01 0 0 ]); %[-.2 -0.089 .15 .15])
        %% move text around
        N = findobj(tmp1h,'type','text');
        pos = get(N,'Position');
        set(N(1),'Position',[.28,.80,0]);
        set(N(2),'Position',[.28,.5,0]);
        set(N(3),'Position',[.28,.2,0]);
        %% remove box:
        legend boxoff
        
        addlabel3(' C ',X,Y,8);
    end
    
    set(gca,'fontsize',6);
    
    
    %% for use with layered plots
    %% set(gca,'box','off')
    
    %% adjust limits
    %% tmpv = axis;
    %% axis([]);
    
    ylim([0,4]);
    xlim([0,4.3]);
    
    %% change axis line width (default is 0.5)
    %% set(tmpaxes(axesnum),'linewidth',2)
    
    %% fix up tickmarks
    set(gca,'xtick',0:4)
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
clear all