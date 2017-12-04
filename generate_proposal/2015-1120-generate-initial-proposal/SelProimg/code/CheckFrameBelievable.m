function IsFrameBelievable = CheckFrameBelievable( IsFrameBelievable_old,allpixnum,iimg,imgnum,img_c,believelable,imgfolder_dir,imgfolder,opticalflowdir,rgbimgfolder_dir)
%����ǰ��֮֡���ͶӰ�����ĳһ֡�Ƿ����
%���������
  %IsFrameBelievable_old������ǰ�����ζȱ�ǩ
  %errth:[��ֵ]��ߴ����ʣ�  allpixnum��ͼƬ���е����ص���Ŀ��  iimg������dir�У�Ŀǰͼ���λ�ã�
  %imgnum��ͼ��������  img_c��Ŀǰ��Ҫ�ж���ͼƬ֡��  believelable�����ζȱ�ǩ
  %imgfolder_dir��imgfolder���ļ��м��������ļ���  
  %opticalflowdir������Ŀ¼
%���������
  %IsFrameBelievable��֡�Ƿ����
  
%����ֵ�������ͶӰ����Ƿ�һ��
% consth=0.1;
  
IsFrameBelievable=IsFrameBelievable_old;
searchindex=[-3,-2,-1,1,2,3];

%��¼��һ֡���ţ��������λ��
belindex=zeros(2,6);
belindex(2,:)=searchindex;
for ibeli=1:6
    csindex=iimg+searchindex(ibeli)-2;
    %��������߽�
    if csindex<1 || csindex>imgnum-2
       continue; 
    else
       if believelable(csindex)==1
           belindex(1,ibeli)=1;
       end           
    end        
end

%�������ȼ����в���
sindexorder=[3,4,2,5,1,6];
if sum(belindex(1,:))>=2
    %����������֡
    chnum=0;
    im_p=cell(1,2);
%     fprintf('check reliable for frame %d with frame \r',iimg-2);
    for ich=1:6
        %�˴������Ż�
        if belindex(1,sindexorder(ich))==1 & chnum<2
            %�ɼ���ͶӰ
            chnum=chnum+1;
            %ͼƬ�����λ��
            p_img=belindex(2,sindexorder(ich));
            if p_img<0
                %��ǰͶӰ
                im_p{chnum}=project_f(imgfolder_dir,rgbimgfolder_dir,imgfolder,opticalflowdir,iimg,p_img);
%                 fprintf('%d ',iimg+p_img-2);
            else
                %���ͶӰ
                im_p{chnum}=project_b(imgfolder_dir,rgbimgfolder_dir,imgfolder,opticalflowdir,iimg,p_img);
%                 fprintf('%d ',iimg+p_img-2);
            end   
        end           
%         fprintf('\r');
    end 
    
    iscon=IsConsistent(allpixnum,im_p{1},im_p{2});
    if iscon==1
        isbel=IsBelievable(img_c,im_p{1},im_p{2},allpixnum); 
    else
        %��Ҫ�Ƚ���ϸ���ж�
        
        chnum=0;
        im_p=cell(1,3);
    %     fprintf('check reliable for frame %d with frame \r',iimg-2);
        for ich=1:2:5
            %�˴������Ż�
            if belindex(1,sindexorder(ich))==1
                %�ɼ���ͶӰ
                chnum=chnum+1;
                %ͼƬ�����λ��
                p_img=belindex(2,sindexorder(ich));
                im_p{chnum}=project_f(imgfolder_dir,rgbimgfolder_dir,imgfolder,opticalflowdir,iimg,p_img);
            end      
        end         
        [rows,cols]=size(img_c);
        pro_res_f=zeros(rows,cols);
        for ipf=1:3
            im_p_c=im_p{ipf};
            if isempty(im_p_c)
               continue; 
            end
            for irow=1:rows
                for jcol=1:cols
                    if im_p_c(irow,jcol)==1
                       pro_res_f(irow,jcol)=pro_res_f(irow,jcol)+255;
                    end
                end
            end
            
        end
        pro_res_f=uint8(pro_res_f);
        isbel=IsBelievable(img_c,pro_res_f,pro_res_f,allpixnum); 
        
    end
      
    if isbel==1
        IsFrameBelievable=1;
    else
        IsFrameBelievable=0;
    end
    
    

end

end

