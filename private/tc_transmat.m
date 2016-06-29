function [ transmat ] = tc_transmat( value,type )

%creates transformation matrix for 3D operations
%[ transmat ] = tc_transmat( value,type )
%
%value is a 1x3 vector containing transformation values for [x,y,z]
%
%type = 'scale' output is scaling matrix
%type = 'translate' output is translation matrix
%type = 'rotate' output is rotation matrix
%
%example: transmat = tc_transmat( [0 90 45],'rotate' );

if size(value,1)==1 && (size(value,2)==3 || size(value,2)==1)
    transmat=eye(4);
    if size(value,2)==1
        value=repmat(value,1,3);
    end
    switch type
        case 'scale'
            transmat(1,1)=value(1);
            transmat(2,2)=value(2);
            transmat(3,3)=value(3);
        case 'translate'
            transmat(1,4)=value(1);
            transmat(2,4)=value(2);
            transmat(3,4)=value(3);
        case 'rotate'
            transmat=...
                [cos(value(3)) -sin(value(3)) 0 0;...
                sin(value(3)) cos(value(3)) 0 0;...
                0 0 1 0;...
                0 0 0 1]*...
                [cos(value(2)) 0 sin(value(2)) 0;...
                0 1 0 0;...
                -sin(value(2)) 0 cos(value(2)) 0;...
                0 0 0 1]*...
                [1 0 0 0;...
                0 cos(value(1)) -sin(value(1)) 0;...
                0 sin(value(1)) cos(value(1)) 0;...
                0 0 0 1];
            
        otherwise
            error('unknown operation')
    end
else
    error('invalid value; must be a 1x3 matrix contaning transformation values for [x,y,z] ')
end
end

