%% KSplots_individual.m
%
% make all of the KS plots

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
clear all
close all
load ../../data/phdata.mat
%% layer plots for each institution
for i=1:6
    tmpfigh = gcf;
    clf;
    figshape(1000,750);
    % automatically create postscript whenever figure is drawn
    tmpfilename = sprintf('KSvsXmin_inst_%d',i);
    
    tmpfilenoname = sprintf('%s_noname',tmpfilename);
    
    %% global switches
    
    set(gcf,'Color','none');
    % set(gcf,'InvertHardCopy', 'off');
    
    set(gcf,'DefaultAxesFontname','helvetica');
    set(gcf,'DefaultLineColor','r');
    set(gcf,'DefaultAxesColor','none');
    set(gcf,'DefaultLineMarkerSize',5);
    set(gcf,'DefaultLineMarkerEdgeColor','k');
    set(gcf,'DefaultLineMarkerFaceColor','g');
    set(gcf,'DefaultAxesLineWidth',0.5);
    set(gcf,'PaperPositionMode','auto');
    
    tmpsym = {'o','s','v','o','s','v','o'};
    tmpcol = {'g','b','r','k','c','m','b'};
    
    positions(1).box = [.2 .2 .7 .7];
    axesnum = 1;
    tmpaxes(axesnum) = axes('position',positions(axesnum).box);
    
    for j=1:length(phdata(i).years)        
        donations = phdata(i).donations(:,j);
        if min(donations)==0
            donations = donations(1:min(find(donations==0))-1);
        end
        
        [alpha,xmin2,L,dat] = plfit_dat(donations);
        
        ud = unique(donations);
        
        %plot(log10(ud(2:end)),dat,'.')
        
        
        line = plot(log10(ud(2:end)),dat(:,1),'Color',0.7*[1 1 1],'LineWidth',1.5);
        hold on;
        
        tmph(1) = plot(log10(ud(2:end)),dat(:,1),'Marker',tmpsym{j},'MarkerFaceColor',tmpcol{j},'LineStyle','none');
        
    end
    
    set(gca,'fontsize',16);
    
    % % legend
    % tmp1h = legend(tmph,phdata(i).years); %,,'Location',[.53,.81,.15,.072]); % [left,bottom,width,height]
    % %set(tmp1h,'position',get(tmp1h,'position')-[0 0 0 0]) %% -[x y 0 0]
    % %% change font
    % %tmplh = findobj(tmplh,'type','text');
    % set(tmp1h,'FontSize',17);
    % %% remove box:
    % legend boxoff
    
    %% use latex interpreter for text, sans serif
    
    tmpxlab=xlabel('$\log_{\,\,10} x_{\min}$','fontsize',23,'verticalalignment','top','fontname','helvetica','interpreter','latex');
    tmpylab=ylabel('KS Statistic $D$','fontsize',23,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');
    
    %% disp(get(tmpxlab,'position'))
    
    %set(tmpxlab,'position',get(tmpxlab,'position') - [0 .001 0]); % [x y 0]
    %set(tmpylab,'position',get(tmpylab,'position') - [0.1 0 0]);
    
    %% keep postscript for publication
    
    psprintcpdf_keeppostscript(tmpfilenoname);
    
    %% automatic creation of postscript
    %% psprintcpdf(tmpfilename);
    
    tmpcommand = sprintf('open %s.pdf;',tmpfilenoname);
    system(tmpcommand);
    
    %% archivify
    %figurearchivify(tmpfilenoname);
    
    close(tmpfigh);
    
end