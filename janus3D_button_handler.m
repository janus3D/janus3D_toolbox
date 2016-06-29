function [ ] = janus3D_button_handler( model,MRI,handles )

if  isfield(model,'VCoord') && isfield(model,'FCoord')
    if  ~isempty(model.VCoord) && ~isempty(model.FCoord)
        set(handles.position_model,'Enable','on')
    else
        set(handles.position_model,'Enable','off')
    end
else
    set(handles.position_model,'Enable','off')
end
if  isfield(model,'positioned')
    set(handles.de_face_model,'Enable','on')
else
    set(handles.de_face_model,'Enable','off')
end
if  isfield(MRI,'VCoord') && isfield(MRI,'FCoord')
    if  ~isempty(MRI.VCoord) && ~isempty(MRI.FCoord)
        set(handles.de_face_MRI,'Enable','on')
    else
        set(handles.de_face_MRI,'Enable','off')
    end
else
    set(handles.de_face_MRI,'Enable','off')
end
if  isfield(MRI,'Face') && isfield(model,'Face')
    if  ~isempty(MRI.Face.VInd) && ~isempty(model.Face.VInd)
        set(handles.align_models,'Enable','on')
    else
        set(handles.align_models,'Enable','off')
    end
else
    set(handles.align_models,'Enable','off')
end

if  isfield(model,'aligned')
    set(handles.correct_alignment,'Enable','on')
    set(handles.manual,'Enable','on')
    if isfield(model,'VTCoord')
        if ~isempty(model.VTCoord) && isfield(model,'texture')
            set(handles.texture_based,'Enable','on')
            if isfield(model,'Electrodes')
                if isfield(model.Electrodes,'points')
                    foldercontent=dir([fileparts(which(mfilename)) filesep 'private' filesep]);
                    foldercontent={foldercontent(:,1).name}';
                    has_temp=find(strcmp(foldercontent,'current_cap_template.mat')==1);
                    if ~isempty(model.Electrodes.points) && size(has_temp,1)~=0                       
                        set(handles.auto_label,'Enable','on')
                    else
                        set(handles.auto_label,'Enable','off')
                    end
                else
                    set(handles.auto_label,'Enable','off')
                end
            else
                set(handles.auto_label,'Enable','off')
            end
        else
            set(handles.texture_based,'Enable','on')
            set(handles.auto_label,'Enable','off')
        end
    else
        set(handles.texture_based,'Enable','off')
        set(handles.auto_label,'Enable','off')
    end
else
    set(handles.correct_alignment,'Enable','off')
    set(handles.manual,'Enable','off')
    set(handles.texture_based,'Enable','off')
    set(handles.auto_label,'Enable','off')
end
if isfield(model,'Electrodes')
    if isfield(model.Electrodes,'points')
        set(handles.show_electrodes,'Enable','on')
    else
        set(handles.show_electrodes,'Enable','on')
    end
end
end

