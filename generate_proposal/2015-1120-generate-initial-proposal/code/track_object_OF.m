function im_tracked_object=track_object_OF(img,frame_index,tracking_frame_index,opticalFlow)
    % Track Object using Optical Flow
    if frame_index>tracking_frame_index
%         fprintf('forward/r/n');
        %��ֵ��ʽ��bicubic��bilinear
        %ʹ�ò�ͬ��ֵ��ʽ�õ��Ľ��һ�£���Ϊ��ֵֻ��0��255
        im_tracked_object=warpByOpticalFlow_dong(img,opticalFlow.vx,opticalFlow.vy,'linear');
    else
        im_tracked_object=warpByOpticalFlow_dong(img,-opticalFlow.vx,-opticalFlow.vy,'linear');
%         fprintf('backward/r/n');
    end
end