
function [output]=tc_pointcloudtocursor(pointcloud,scale)
surface_mouse=[];
surface_mouse2=[];
diff_mid_surf=[0,0];
theta=0;
key_ind=0;
pointcloud_new=[];
pointcloud=pointcloud.*scale;
set (gcf, 'WindowButtonMotionFcn', @mouseMove);
set (gcf, 'WindowButtonDownFcn', @done);
set (gcf, 'WindowScrollWheelFcn',@rotateMove);
set(gcf, 'WindowKeyPressFcn', @KeyPress)
set(gcf, 'WindowKeyReleaseFcn', @KeyRelease)


    function KeyPress(source, callback)
        if strcmp(callback.Key,'control')
            key_ind=1;
        end
        if strcmp(callback.Key,'escape')
            pointcloud_new=[];
            delete(h)
        end
    end

    function done(source, callback)
        delete(surface_mouse2);
        pointcloud_new=pointcloud;
        pointcloud_new(:,1)=pointcloud(:,3);
        pointcloud_new(:,2)=pointcloud(:,1);
        pointcloud_new(:,3)=pointcloud(:,2);
        hold on
        surface_mouse2=plot3((pointcloud_new(:,1)),(pointcloud_new(:,2)),(pointcloud_new(:,3)),'b');
        hold off
        delete(surface_mouse)
    end

    function KeyRelease(source, callback)
        key_ind=0;
    end

    function mouseMove(source, callback)
        pointcloud=pointcloud(:,1:2);
        delete(surface_mouse)
        val=get(gca,'CurrentPoint');
        val(2:end,:)=[];
        val(:,1)=val(:,2);
        val(:,2)=val(:,3);
        val(:,3)=val(:,1);
        
        pointcloud=pointcloud(:,1:2);
        mid_surf=mean(pointcloud);
        
        diff_mid_surf=val(1,1:2)-mid_surf;
        clickedPt = get(gca,'CurrentPoint');
        point2d =clickedPt(1,1);
        pointcloud=pointcloud+repmat(diff_mid_surf,size(pointcloud,1),1);
        pointcloud(:,3)=repmat(point2d,size(pointcloud,1),1);
        hold on
        surface_mouse=plot3((pointcloud(:,3)),(pointcloud(:,1)),(pointcloud(:,2)),'g');
        set(gca,'color','none')
        axis off
        hold off
    end
    function rotateMove(source, callback)
        pointcloud=pointcloud(:,1:2);
        if key_ind==1;
            delete(surface_mouse)
            clickedPt = get(gca,'CurrentPoint');
            point2d =clickedPt(1,1);
            scale=1;
            count_scroll=callback.VerticalScrollCount;
            scale=scale+key_ind*count_scroll./100;
            mid_surf1=mean(pointcloud);
            pointcloud=pointcloud.*(scale);
            mid_surf2=mean(pointcloud);
            
            corr_surf=mid_surf1-mid_surf2;
            pointcloud=pointcloud+repmat(corr_surf,size(pointcloud,1),1);
            pointcloud(:,3)=repmat(point2d,size(pointcloud,1),1);
            hold on
            surface_mouse=plot3((pointcloud(:,3)),(pointcloud(:,1)),(pointcloud(:,2)),'g');
            set(gca,'color','none')
            axis off
            hold off
        else
            theta=0;
            count_scroll=callback.VerticalScrollCount;
            theta=theta+count_scroll./50;
            delete(surface_mouse)
            mid_surf=mean(pointcloud);
            clickedPt = get(gca,'CurrentPoint');
            point2d =clickedPt(1,1);
            R = [cos(theta) -sin(theta); sin(theta) cos(theta)];
            
            pointcloud=R*(pointcloud-repmat(mid_surf,size(pointcloud,1),1))';
            pointcloud=pointcloud';
            pointcloud=pointcloud+repmat(mid_surf,size(pointcloud,1),1);
            pointcloud(:,3)=repmat(point2d,size(pointcloud,1),1);
            hold on
            surface_mouse=plot3((pointcloud(:,3)),(pointcloud(:,1)),(pointcloud(:,2)),'g');
            set(gca,'color','none')
            axis off
            hold off
        end
        
    end

waitfor(gca)
delete(surface_mouse)
delete(surface_mouse2)
output=pointcloud_new;
set(rotate3d,'Enable','off');
set(pan,'Enable','off');
set(zoom,'Enable','off');
set (gcf, 'WindowButtonMotionFcn', '');
set (gcf, 'WindowButtonDownFcn', '');
set (gcf, 'WindowScrollWheelFcn','');
set(gcf, 'WindowKeyPressFcn', '')
set(gcf, 'WindowKeyReleaseFcn', '')
end