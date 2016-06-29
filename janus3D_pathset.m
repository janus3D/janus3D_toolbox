function [  ] = janus3D_pathset( case_ )

%%% adds/removes folders from '~/janus3D/external/' folder to/from MATLAB search path %%%
folder=dir([fileparts(mfilename('fullpath')),filesep 'external' filesep]);
fold_ind=intersect(find(cell2mat(cellfun(@(x) x==1, {folder.isdir},'unif',0))==1),find(cell2mat(cellfun(@(x) ~strcmpi(x(1),'.'), {folder.name},'unif',0))==1));
folder={folder.name};
folder=folder(fold_ind);

switch case_
    
    case 'add'
        cellfun(@(x) addpath(genpath([fileparts(mfilename('fullpath')),filesep 'external' filesep x filesep])),folder);
    case 'rm'
        cellfun(@(x) rmpath(genpath([fileparts(mfilename('fullpath')),filesep 'external' filesep x filesep])),folder);
end

end

