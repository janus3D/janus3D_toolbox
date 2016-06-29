function [ Model ] = tc_readObj( filename )


[pathstr,name,ext] = fileparts((filename));

copyfile(filename,[name '_tmp' ext])

filename=[name '_tmp' ext];

movefile(filename, fullfile(pathstr, [name '_tmp.txt']))

filename=[pathstr,filesep,name '_tmp.txt'];

fid=fopen(filename,'rt');
[pathstr,name,ext] = fileparts((filename));

fid=fopen([pathstr,filesep,name '.txt'],'rt');
Model=textscan(fid,'%s','Delimiter','\n');
fclose(fid);
Model=Model{1,1};
vt_index=strfind(Model,'vt ');
emptyIndex = cellfun(@isempty,vt_index);
vt_index(emptyIndex) = {0};
vt_index=cell2mat(vt_index);

v_index=strfind(Model,'v ');
emptyIndex = cellfun(@isempty,v_index);
v_index(emptyIndex) = {0};
v_index=cell2mat(v_index);

f_index=strfind(Model,'f ');
emptyIndex = cellfun(@isempty,f_index);
f_index(emptyIndex) = {0};
f_index=cell2mat(f_index);

V=Model(find(v_index==1),:);

V_coord=cell2mat(cellfun(@(x) sscanf(x,'v %f %f %f',3)',V,'unif',0));

VT=Model(find(vt_index==1),:);

VT_coord=cell2mat(cellfun(@(x) sscanf(x,'vt %f %f',2)',VT,'unif',0));

F=Model(find(f_index==1),:);

if ~isempty(VT_coord)
    F_coord=cell2mat(cellfun(@(x) sscanf(x,'f %d/%d %d/%d %d/%d',6)',F,'unif',0));
else
    F_coord=cell2mat(cellfun(@(x) sscanf(x,'f %d %d %d',3)',F,'unif',0));
end

v_index=find(v_index==1);
vt_index=find(vt_index==1);
f_index=find(f_index==1);

Model_char=char(Model);
Model_char([v_index',vt_index',f_index'],:)=[];
Model_char_ind=1:size(Model,1);
Model_char_ind(:,[v_index',vt_index',f_index'])=[];
Model_char_ind=Model_char_ind';

delete([pathstr,filesep,name '.txt'])

Model=[];
Model.VCoord=V_coord;
Model.VIndices=v_index;
Model.VTCoord=VT_coord;
Model.VTIndices=vt_index;
Model.FCoord=F_coord;
Model.FIndices=f_index;
Model.ModelSpecs=Model_char;
Model.ModelSpecsIndices=Model_char_ind;

end

