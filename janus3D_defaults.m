function [ ] = janus3D_defaults(handles,keep_var)
set(gcf, 'pointer', 'arrow')
set(rotate3d,'Enable','off');
set(pan,'Enable','off');
set(zoom,'Enable','off');
set(gcf, 'WindowButtonUpFcn', '');
set(gcf, 'WindowButtonDownFcn', '');
if strcmp(keep_var,'no')
    delete(findobj(get(handles.subfunparent,'Children'),'Type','uicontrol','-not','tag','status_handler'))
    delete(get(handles.uipanel7,'Children'))
end
drawnow;
end

