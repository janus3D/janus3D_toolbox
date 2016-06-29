function [ SortedText,I ] = tc_sortalphanum( UnSortedText )
%sorts alphabetically but with respect to values of numbers
% e.g. a2 c5 b3 a10 b1 c15 would be sorted as {a2, a10, b1, b3, c5, c15}
% [ SortedText,I ] = tc_sortalphanum( UnSortedText )
[R,~,notR,~] = regexp(UnSortedText ,'(?<Name>\D+)(?<Nums>\d+)','names','match','split');
notfound=find(cellfun(@isempty,R)==1);
if ~isempty(notfound)
    R(notfound,1)=cellfun(@(x) struct('Name',x,'Nums',cell(1)),vertcat(notR{notfound,1}),'unif',0);
end
R=cell2mat(R);
[tmp,I] = sortrows([{R.Name}' num2cell(cellfun(@(x)str2double(x),{R.Nums}'))]);
tmp(find(cell2mat(cellfun(@(x) isnan(x), tmp(:,2),'unif',0))==1),2)=cell(1,1);
SortedText = strcat(tmp(:,1) ,cellfun(@(x) num2str(x), tmp(:,2),'unif',0));
end