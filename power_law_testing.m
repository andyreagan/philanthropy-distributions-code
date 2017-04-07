load ../../data/phdata.mat

for i = 1:1
    for j=1:1 %length(phdata(i).years)
        % load that year
        donations = phdata(i).donations(:,j);
        
        % clean the data a little: get rid of 0's
        if min(donations)==0
            donations = donations(1:min(find(donations==0))-1);
        end
        
        [alpha,xmin,L] = plfit(donations);
        [alpha_var,xmin_var,ntail] = plvar(donations);
        [p, gof] = plpva(donations,xmin);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% testing p over all xmin
i=1;
j=1;
donations = phdata(i).donations(:,j);
if min(donations)==0
    donations = donations(1:min(find(donations==0))-1);
end
% find p, D over the different xmin to plot
p_store = zeros(size(donations));
gof_store = zeros(size(donations));
for i=10:length(donations(10:end))
    tic;
    fprintf('fitting w xmin=%f\n',donations(i));
    [p,gof] = plpva(donations,donations(i),'reps',1000,'silent');
    p_store(i) = p;
    gof_store(i) = gof;
    toc;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% test L over all xmin
i=1;
j=1;
donations = phdata(i).donations(:,j);
if min(donations)==0
    donations = donations(1:min(find(donations==0))-1);
end
% find L over the range of xmin
L_store = zeros(size(donations));
for i=10:length(donations(10:end))
    xmin = donations(i);
    %fprintf('fitting w xmin=%f\n',xmin);
    [alpha,xmin2,L] = plfit(donations,xmin);
    L_store(i) = L;
end

plot(donations(:),L_store(:),'.')




