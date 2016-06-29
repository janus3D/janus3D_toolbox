function [ sorted,I ] = tc_sortlabelslike( to_be_sorted,like )

%[ sorted,I ] = tc_sortlabelslike( to_be_sorted,like )
%sorts cells containing string after a template of strings and returns
%sorted string-cells and indices
%input must be n x 1 or 1 x n cell arrays containing strings
%
%example:
%template={'AB','CD','EF','GH'};
%to_be_sorted={'GH','CD','AB','EF};
%[ sorted,I ] = tc_sortlabelslike( to_be_sorted,template );
%sorted
%'AB','CD','EF','GH'
%I
%[3,2,4,1]
transpose=0;
if  size(to_be_sorted,2)>1
    to_be_sorted=to_be_sorted';
    transpose=1;
end
if  size(like,2)>1
    like=like';
end

if ~iscell(to_be_sorted) || ~iscell(like)
    error('inputs must be cell arrays of type n x 1')
elseif sum(cellfun(@(x) ~ischar(x),to_be_sorted))>0 || sum(cellfun(@(x) ~ischar(x),like))>0
    error('inputs must contain strings')
elseif size(find(ismember(to_be_sorted,like)==0),1)>0
    error('label mismatch - labels must be equal')
end

cellfind = @(string)@(cell_contents)(strcmp(string,cell_contents));
I=cellfun(@(x) find(x==1),cellfun(cellfind(to_be_sorted),like,'unif',0));
sorted=to_be_sorted(I,:);

if  transpose==1
    sorted=sorted';
    I=I';
end

end

