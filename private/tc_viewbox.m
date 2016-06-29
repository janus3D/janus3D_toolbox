function [ viewbox ] = tc_viewbox( varargin)

%[ viewbox ] = tc_viewbox( axeshandle,color )
%[ viewbox ] = tc_viewbox( axeshandle )
%[ viewbox ] = tc_viewbox( color )
%[ viewbox ] = tc_viewbox( )
%creates line object that surrounds the current axes limits
%
%specify axes by setting axeshandle
%specify color by setting color in common MATLAB color style
%
%empty variables are set to MATLAB default
if size(varargin,2)==0
    axeshandle=gca;
    color='default';
elseif size(varargin,2)==1
    if ishandle(varargin{1})
        axeshandle = varargin{1};
        color='default';
    elseif ischar(varargin{1}) || isnumeric(varargin{1})
        if ~tc_iscolor(varargin{1})
            warning('Color value must be a 3 element vector or string specifying color - color value was set to default')
            color='default';
        else
            color=varargin{1};
        end
        axeshandle=gca;
    else
        error('invalid parameter settings - type "help tc_viewbox" for further information')
    end
elseif size(varargin,2)==2
    if ishandle(varargin{1}) && (ischar(varargin{2}) || isnumeric(varargin{2}))
        axeshandle=varargin{1};
        if ~tc_iscolor(varargin{2})
            warning('Color value must be a 3 element vector or string specifying color - color value was set to default')
            color='default';
        else
            color=varargin{2};
        end
    else
        error('invalid parameter settings - type "help tc_viewbox" for further information')
    end
else
    error('invalid parameter settings - type "help tc_viewbox" for further information')
end
XL=get(axeshandle,'xlim');
YL=get(axeshandle,'ylim');
ZL=get(axeshandle,'zlim');
viewbox=line([XL(1) XL(2) XL(2) XL(1) XL(1);XL(1) XL(2) XL(2) XL(1) XL(1);XL(1) XL(1) XL(1) XL(1) XL(1);XL(2) XL(2) XL(2) XL(2) XL(2)]',...
    [YL(1) YL(1) YL(1) YL(1) YL(1);YL(2) YL(2) YL(2) YL(2) YL(2);YL(1) YL(2) YL(2) YL(1) YL(1);YL(1) YL(2) YL(2) YL(1) YL(1)]',...
    [ZL(1) ZL(1) ZL(2) ZL(2) ZL(1);ZL(1) ZL(1) ZL(2) ZL(2) ZL(1);ZL(1) ZL(1) ZL(2) ZL(2) ZL(1);ZL(1) ZL(1) ZL(2) ZL(2) ZL(1)]'...
    ,'Color',color,'Parent',axeshandle);
end

