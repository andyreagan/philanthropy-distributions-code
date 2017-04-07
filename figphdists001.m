load ../../data/phdata.mat

tmpfigh = gcf;
clf;
figshape(1000,750);
% automatically create postscript whenever figure is drawn
tmpfilename = 'figphdists001';

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

tmpsym = {'o','s','v','o','s','v'};
tmpcol = {'g','b','r','k','c','m'};

%%%%%%%%%%%%%%%%%%%
tmpx1 = 0.15;
tmpy1 = 0.20;
tmpy2 = 0.56;

tmpxg1 = 0.02;
tmpxg2 = 0.02;
% tmpxg3 = 0.04;

tmpyg1 = 0.05;

tmpw1 = 0.20;
tmpw2 = 0.20;
% tmpw3 = 0.22;

tmph1 = 0.30;

positions(1).box = [tmpx1                    , tmpy2, tmpw1, tmph1];
positions(2).box = [tmpx1 + tmpw1 + tmpxg1 , tmpy2, tmpw2, tmph1];
positions(3).box = [tmpx1 + tmpw1 + tmpw2 + tmpxg1 + tmpxg2, tmpy2, tmpw2, tmph1];
positions(4).box = [tmpx1                    , tmpy1, tmpw1, tmph1];
positions(5).box = [tmpx1 + tmpw1 +  tmpxg1, tmpy1, tmpw2, tmph1];
positions(6).box = [tmpx1 + tmpw1 + tmpw2 + tmpxg1 + tmpxg2, tmpy1, ...
    tmpw2, tmph1];

tmplabels = {' A ',' B ',' C ',' D ',' E ',' F '};

% plot a fit to the power law
% N are [9766 7796 31244 9024 377 2530]
fit_lower=[1 1 3 1 2 1];
fit_upper=[90 2000 floor(10^2.9) floor(10^2.5) 88 2000];

offset=[-.7 -.75 -1.2 -.85 1.45 .6];

% each entry is a matrix of all seven parameters (across) for each fitted
% year from Clauset stuff
MLE_data_cell = cell(1,8);
LS_data_cell = cell(1,6);
for i=1:8 % p gof fit_l fit_u gamma gamma_conf alpha alpha_conf
    MLE_data_cell{i} = zeros(7,6);
end
for i=1:6 % fit_l fit_u gamma gamma_conf alpha alpha_conf
    LS_data_cell{i} = zeros(7,6);
end

for i = 1:6 % all 6 institutions
    
    axesnum = i;
    tmpaxes(axesnum) = axes('position',positions(axesnum).box);
    clear tmph;
    tmph=zeros(1,min(length(phdata(i).years),5));
    legendcell = cell(1,length(phdata(i).years));
    for j=1:length(phdata(i).years)
        % load that year
        % BUT GO IN REVERSE!!!! (want 2010 first) aka 2nd entry of Sinai
        % first
        donations = phdata(i).donations(:,-j+1+length(phdata(i).years));
        
        fprintf('on %s for year %d',phdata(i).name,phdata(i).years(:,-j+1+length(phdata(i).years)));
        
        % clean the data a little: get rid of 0's
        if min(donations)==0
            donations = donations(1:min(find(donations==0))-1);
        end
        
        if j<6
            % plot grey line
            tmphl = plot(log10(1:length(donations)),log10(donations),'Color',0.7*[1 1 1]);
            hold on;
            
            % make same years have same marks
            yearlabel=mod(find(1974:2015==phdata(i).years(-j+1+length(phdata(i).years)),1),6)+1;
 
            % plot points evenly in log space
            length(donations);
            pts2plot = spacepts(1,length(donations),60,1);
            
            % plot that guy
            tmph(j) = plot(log10(pts2plot),log10(donations(pts2plot)),'Marker',tmpsym{yearlabel},'MarkerFaceColor',tmpcol{yearlabel},'LineStyle','none');
        end
        
        % fit power law with least squares in log-log space (fast, so always do it)
        [alpha_LS,gamma_LS,alpha_conf_LS,gamma_conf_LS]=plotpowerfit(fit_lower(i):fit_upper(i),donations(fit_lower(i):fit_upper(i)),'Plotoff','yes','method','LS');
        
            
        if j==1 % plot, and save the fit, for the first one
            [alpha,gamma,alpha_conf,gamma_conf,p,gof]=plotpowerfit(fit_lower(i):fit_upper(i),donations(fit_lower(i):fit_upper(i)),'Offset',offset(i),'gammaconfrep',2,'prep',2);
        else % save the data regardless of plotswitch
            [alpha,gamma,alpha_conf,gamma_conf,p,gof]=plotpowerfit(fit_lower(i):fit_upper(i),donations(fit_lower(i):fit_upper(i)),'Offset',offset(i),'Plotoff','yes','gammaconfrep',2,'prep',2);
        end
        
        legendcell{j} = sprintf('%d  %1.2f  %1.2f',phdata(i).years(-j+1+length(phdata(i).years)),alpha,gamma);
        
        % p gof fit_l fit_u gamma gamma_conf alpha alpha_conf
        MLE_data = [p,gof,fit_lower(i),fit_upper(i),gamma,gamma_conf,alpha,alpha_conf];
        LS_data = [fit_lower(i),fit_upper(i),gamma_LS,gamma_conf_LS,alpha_LS,alpha_conf_LS];
        for k=1:8
            MLE_data_cell{k}(-j+1+length(phdata(i).years),i) = MLE_data(k);
        end
        for k=1:6
            LS_data_cell{k}(-j+1+length(phdata(i).years),i) = LS_data(k);
        end
    end

    set(gca,'fontsize',12);
    set(gca,'color','none');
    
    ylim([0 8]);
    xlim([0 4.5]);
    
    if (i==5)
        tmpxlab=xlabel('$\log_{\,10}$ Gift rank $r$', ...
            'fontsize',19,'verticalalignment','top','fontname','helvetica','interpreter','latex');
        set(tmpxlab,'position',get(tmpxlab,'position') - [0 .07 0]);
    end
    if (i==4)
        tmpylab=ylabel('$\log_{\,10}$ Gift size $S$','fontsize',19,'verticalalignment','bottom','fontname','helvetica','interpreter','latex');
        set(tmpylab,'position',get(tmpylab,'position') + [.05 4 0]);
    end
    
    
    % fix up tickmarks
    set(gca,'ytick',[1:8]);
    % set(gca,'xticklabel',{'','',''})
    
    % change axis line width (default is 0.5)
    set(tmpaxes(axesnum),'linewidth',0.6)
    
    % legend    
    tmplh = legend(tmph,legendcell,'location','northeast');
    set(tmplh,'position',get(tmplh,'position')+[0.015 -0.01 0 0])
    % change font
    tmplh = findobj(tmplh,'type','text');
    set(tmplh,'FontSize',10);
    % remove box:
    legend boxoff
    % use latex interpreter for text, sans serif
    
    tmpXcoord = 0.16;
    
    tmpYcoord = 0.08;
    tmpstr = {sprintf('%s',phdata(i).name)};
    
    if i==2
        tmpstr{1} = 'Einstein';
        tmpstr{2} = 'School of Medicine';
    end
    if i==3
        tmpstr{1} = 'University of Vermont';
    end
    if i==4
        tmpstr{1} = 'United Way of';
        tmpstr{2} = 'Chittenden County';
    end
    
    % label (A, B, ...)
    addlabel3(tmplabels{i},0.035,0.08,14);
    
    text(tmpXcoord,tmpYcoord,tmpstr,...
        'fontsize',12,...
        'fontname','helvetica',...
        'units','normalized'... % ,...
        ); %'interpreter','tex');
    
    tmpstr = 'Year      \alpha       \gamma';
    whereY=[.95 .95 .95 .95 .95 .95]+.012;
    whereX=[.40 .40 .40 .40 .40 .40]+.2;
    text(whereX(i),whereY(i),tmpstr,...
        'fontsize',10,...
        'fontname','helvetica',...
        'units','normalized',...
        'interpreter','tex');
end

psprintcpdf_keeppostscript(tmpfilenoname);
close(tmpfigh);

tmpcommand = sprintf('open %s.pdf;',tmpfilenoname);
system(tmpcommand);

saved_variables = {'p','gof','fit_l','fit_u','gamma','gamma_conf','alpha','alpha_conf'};
method = 'MLE';
for i=1:8
    csvwrite(sprintf('inst_%s_%s.csv',saved_variables{i},method),MLE_data_cell{i});
end
method = 'LS';
for i=1:6
    csvwrite(sprintf('inst_%s_%s.csv',saved_variables{i+2},method),LS_data_cell{i});
end
