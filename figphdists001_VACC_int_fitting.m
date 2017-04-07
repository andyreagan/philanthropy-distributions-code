% set up to run on the VACC for each inst, year
load phdata.mat

% each entry is a matrix of all seven parameters (across) for each fitted
% year from Clauset stuff
MLE_data_cell = {};
n_inst = length(phdata);
for i=1:n_inst
    MLE_data_cell{i} = ones(length(phdata(i).years),9);
end

% need to set i: looping 1 to 6
i = str2num(getenv('INST_NUM'));

% also need to set j: looping 1 to 7
j = str2num(getenv('YEAR_NUM'));


if length(phdata(i).years) > j-0.5
    % load that year
    donations = phdata(i).donations(:,-j+1+length(phdata(i).years));
    
    % clean the data a little: get rid of 0's
    donations = donations(1:min(find(donations==0))-1);
    
    % ensure that it will run as INT
    donations = floor(donations);
    
    [alpha,xmin,L] = plfit(donations);
    [alpha_var,xmin_var,ntail] = plvar(donations);
    [p, gof] = plpva(donations,xmin);
    
    MLE_data_cell{i}(j,:) = [phdata(i).years(j),alpha,xmin,L,alpha_var,xmin_var,ntail,p,gof];
    
    
    save('MLE_fit_data_int.mat','MLE_data_cell');
else
    fprintf('not %d years in %i inst');
end















