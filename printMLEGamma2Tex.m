% simply load these things, and make a latex table of them

clear all

load MLE_fit_data3.mat
load LS_fit_data.mat
load ../../data/phdata.mat

% variables that these things loaded?
who

% don't center the table
center = 0;

f = fopen('../../philanthropy-distributions.supplementary.tex','w');

fprintf(f,'\\begin{table}[h!]\n');
fprintf(f,'\\caption{Distribution fitting}\n');
if center; fprintf(f,'\\begin{center}\n'); end
%fprintf(f,'\\begin{tabular}{|c|l|}\n'); % {\\textwidth}
fprintf(f,'\\begin{tabular}{|c|c|c|c|c|c|c|c|c|c|}\n'); % {\\textwidth}


% print the header
%\begin{tabular}{|l|l|}
fprintf(f,'\\hline\n');
%fprintf(f,'{\\bf Institution} & \\begin{tabular}{l|l|l} {\\bf Year} & {\\bf LS $\\gamma$    } & {\\bf LS Fit Range} \\end{tabular} \\\\ \\hline\n');
fprintf(f,'{\\bf Institution} & {\\bf Year} & {\\bf LS $\\gamma$    } & {\\bf LS Range} & {\\bf MLE $\\gamma$} & {\\bf MLE $x_\\text{min}$ } & {\\bf L } & {\\bf ntail } & {\\bf p } & {\\bf gof } \\\\ \n');
fprintf(f,'\\hline\n');
fprintf(f,'\\hline\n');
for i=1:length(MLE_data_cell)
    for j=1:length(MLE_data_cell{i}(:,1))
        if j == ceil(length(MLE_data_cell{i}(:,1))/2)
            if j == 1
                fprintf(f,'\\centering %s ',phdata(i).name);
            else
                fprintf(f,'%s ',phdata(i).name);
            end
        end
        %fprintf(f,'& \\begin{tabular}{l|l|l}');
        %fprintf(f,'& \\begin{tabular}{c|c|c}');
        fprintf(f,'& ~%d ~',MLE_data_cell{i}(j,1)); % year
        fprintf(f,'& ~%.2f $\\pm$ %.2f ~',LS_data_cell{i}(j,2),LS_data_cell{i}(j,4)); % LS gamma \pm
        fprintf(f,'& %3.0f to %6.0f',LS_data_cell{i}(j,5),LS_data_cell{i}(j,6)); % LS gamma \pm
        fprintf(f,'& ~%.2f $\\pm$ %.2f ~',MLE_data_cell{i}(j,2),MLE_data_cell{i}(j,5)); % MLE gamma \pm
        fprintf(f,'& ~%.f $\\pm$ %.f ~',MLE_data_cell{i}(j,3),MLE_data_cell{i}(j,6)); % MLE gamma \pm
        fprintf(f,'& ~%.2f ',MLE_data_cell{i}(j,4)); % MLE gamma \pm
        fprintf(f,'& ~%.2f ',MLE_data_cell{i}(j,7)); % MLE gamma \pm
        fprintf(f,'& ~%.2f ',MLE_data_cell{i}(j,8)); % MLE gamma \pm
        fprintf(f,'& ~%.2f ',MLE_data_cell{i}(j,9)); % MLE gamma \pm
        %fprintf(f,'\\end{tabular}');
        fprintf(f,'\\\\\n');
    end
    fprintf(f,'\\hline\n');
end
fprintf(f,'\\end{tabular}\n');
if center; fprintf(f,'\\end{center}\n'); end
fprintf(f,'\\vspace{-0.4cm}\n');
fprintf(f,'\\label{table:fitdata}\n');
fprintf(f,'\\end{table} \n');

fclose(f);

!cd ~/work/2012/2012-01philanthropy-distributions; ./makerevtex4.pl
!open ../../philanthropy-distributions-revtex4.pdf