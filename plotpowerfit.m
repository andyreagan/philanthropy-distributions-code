function [alphaval,gammaval,alphadel,gammadel,p,gof] = plotpowerfit(X,Y,varargin)
% PLOTPOWERFIT plots a line of best fit to a power law data
%   Inputs are:
%       X,Y: data to fit
%       a whole bunch of key-value pairs, self explanatory below
%
%   Returns:
%       alpha: zipf's alpha measure over range of fit
%       gamma: corresponding gamma of distribution

%% defaults
linecolor = 0.5*[1 1 1];
bracketcolor = 0.3*[1 1 1];
linewidth = 1.7;
h = .1;
plotoverX = 0;
offset = .5;
minplot = min(X);
maxplot = max(X);
plotbool = 1;
fit = 'clauset';
gammaconfrep = 1000;
prep = 1000;

% if they were set in the call
for i=1:2:nargin-2
    if strcmp(varargin{i},'LineColor')
        linecolor = varargin{i+1};
    end
    if strcmp(varargin{i},'BracketColor')
        bracketcolor = varargin{i+1};
    end
    if strcmp(varargin{i},'h')
        h = varargin{i+1};
    end
    if strcmp(varargin{i},'Offset')
        offset = varargin{i+1};
    end
    if strcmp(varargin{i},'MinPlot')
        minplot = varargin{i+1};
    end
    if strcmp(varargin{i},'MaxPlot')
        maxplot = varargin{i+1};
    end
    if strcmp(varargin{i},'Plotoff')
        plotbool = 0;
    end
    if strcmp(varargin{i},'method')
        fit = varargin{i+1};
    end
    if strcmp(varargin{i},'gammaconfrep')
        gammaconfrep = varargin{i+1};
    end
    if strcmp(varargin{i},'prep')
        prep = varargin{i+1};
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% least squares
if strcmp(fit,'LS')
    [P,S] = polyfit(log10(X)',log10(Y),1);
    [~,alphadel] = polyconf(P,log10(X)',S);
    disp(P)
    % plot the fit
    if plotbool
        % going to use a patch
        tmpX = [log10(minplot) log10(minplot) log10(maxplot) log10(maxplot)]; % left left right right
        tmpY = [polyval(P,log10(minplot)) polyval(P,log10(minplot)) polyval(P,log10(maxplot)) polyval(P,log10(maxplot))]+h/4*[-1 1 1 -1]+offset; % bottom top top bottom
        patch(tmpX,tmpY,linecolor,'EdgeColor',linecolor);
        
        % here are some brackets at the end
        % left
        tmpX = log10(minplot)+h/16*[-1 -1 1 1]+h/16;
        tmpY = polyval(P,log10(minplot))+offset+h.*[-1 1 1 -1];
        patch(tmpX,tmpY,bracketcolor,'EdgeColor',bracketcolor);
        % right
        tmpX = log10(maxplot)+h/16*[-1 -1 1 1];
        tmpY = polyval(P,log10(maxplot))+offset+h.*[-1 1 1 -1];
        patch(tmpX,tmpY,bracketcolor,'EdgeColor',bracketcolor);
    end
    
    % return desired alpha, gamma
    alphaval = -P(1);
    gammaval = 1+1/(alphaval);
    alphadel=mean(alphadel);
    gammadel = abs(gammaval-(1+1/(alphaval+alphadel)));
    p = -1;
    gof = -1;   
    fprintf('LS found gamma of %.2f\\pm %.2f\n',gammaval,gammadel)
    fprintf('LS found alpha of %.2f\\pm %.2f\n',alphaval,alphadel)
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MLE
if strcmp(fit,'clauset')
    % force the continuous approximation (for speed)
    Y(1) = Y(1)+.01;
    [gammaval,xmin,~] = plfit(Y,'xmin',min(Y));
    [gammadel,~,~] = plvar(Y,'xmin',min(Y),'reps',gammaconfrep,'silent');
    [p,gof] = plpva(Y,xmin,'reps',prep,'silent');
    alphaval = 1/(gammaval-1);
    alphadel = abs(1/((gammaval-gammadel)-1)-alphaval);
    fprintf('MLE found gamma of %.2f\\pm %.2f using xmin of %f (should be %f)\n',gammaval,gammadel,xmin,min(Y))
    fprintf('MLE found alpha of %.2f\\pm %.2f using xmin of %f (should be %f)\n',alphaval,alphadel,xmin,min(Y))
    P = [-alphaval log10(Y(1))];
    disp(P)
    if plotbool
        % going to use a patch
        tmpX = [log10(minplot) log10(minplot) log10(maxplot) log10(maxplot)]; % left left right right
        disp(tmpX)
        tmpY = [polyval(P,log10(minplot)) polyval(P,log10(minplot)) polyval(P,log10(maxplot)) polyval(P,log10(maxplot))]+h/4*[-1 1 1 -1]+offset; % bottom top top bottom
        disp(tmpY)
        plot(tmpX(2:3),tmpY(2:3))
        hold on;
        patch(tmpX,tmpY,linecolor,'EdgeColor',linecolor);
                
        % here are some brackets at the end
        % left
        tmpX = log10(minplot)+h/16*[-1 -1 1 1]+h/16;
        tmpY = polyval(P,log10(minplot))+offset+h.*[-1 1 1 -1];
        patch(tmpX,tmpY,bracketcolor,'EdgeColor',bracketcolor);
        % right
        tmpX = log10(maxplot)+h/16*[-1 -1 1 1];
        tmpY = polyval(P,log10(maxplot))+offset+h.*[-1 1 1 -1];
        patch(tmpX,tmpY,bracketcolor,'EdgeColor',bracketcolor);
    end
end