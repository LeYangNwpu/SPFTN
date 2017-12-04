%������д������ص�ĸ���
clear
clc

exapimgdir='D:\ProgramFiles\Matlab\Work\Weakly video segmentation\KeySegments\IniSeg\dataset\image\proresult\girl\examplar\';
imgdatasetdir='D:\ProgramFiles\Matlab\Work\Weakly video segmentation\KeySegments\IniSeg\dataset\image\proresult\girl\';
opticalflowdir='D:\ProgramFiles\Matlab\Work\Weakly video segmentation\KeySegments\IniSeg\dataset\feature\opticalflow\girl\';
exapimgfolder=dir(exapimgdir);
[imgnum,~]=size(exapimgfolder);
img_c=imread([exapimgdir,exapimgfolder(3).name]);
[rows,cols]=size(img_c);
allpixelnum=rows*cols;

errth=0.3;

bellable=zeros(imgnum-2,10);
%��ʼ�ж�ÿһ֡�ܷ�����ͶӰ
for iimg=3:imgnum  
    frameindex=iimg-2;
    imgname=exapimgfolder(iimg).name;
    img_expa=imread([exapimgdir,imgname]);
    for ihyp=1:10
        hypfolderdir=[imgdatasetdir,num2str(ihyp),'\'];        
        img_hyp=imread([hypfolderdir,imgname]);
        errpixsum=sum(sum(xor(img_expa,img_hyp)));

        if (errpixsum/allpixelnum)<errth
            bellable(frameindex,ihyp)=1; 
        end
    end
end

%���ù���ͶӰ����������
searchindex=[-3,-2,-1,1,2,3];
mulproers=cell(6,1);
%�ص��ʴ���0.8ʱ����
recth=0.8;
% imgnum

for iimg=3:imgnum
    iimg
    ischanged=0;
%     %��¼��һ֡���ţ��������λ��
% belindex=zeros(2,6);
% belindex(2,:)=searchindex;
    for ibeli=1:6
        csindex=iimg+searchindex(ibeli)-2;
        %��������߽�
        if csindex<1 || csindex>imgnum-2
           continue; 
        else
            %ͶӰ
            p_img=searchindex(ibeli);
             if p_img<0
                %��ǰͶӰ
                mulproers{ibeli}=project_f(exapimgdir,exapimgfolder,opticalflowdir,iimg,p_img);
            else
                %���ͶӰ
                mulproers{ibeli}=project_b(exapimgdir,exapimgfolder,opticalflowdir,iimg,p_img);
            end  
        end        
    end
     
    pro_base=zeros(rows,cols);
    %�˴�������Ҫ�Ż�
    for ibeli=1:6
        a_pro=mulproers{ibeli};
        if isempty(a_pro)
            continue;
        else
           
            for ipro=1:rows
                for jpro=1:cols                    
                    if  a_pro(ipro,jpro)==1
                        pro_base(ipro,jpro)=pro_base(ipro,jpro)+1;
                    end
                end
            end            
        end
    end
    
    %һ��ͶӰ����Ŀ������Ϊ2
    pro_res=zeros(rows,cols);
    pro_res=uint8(pro_res);
    conproth=2;
    for irow=1:rows
        for jcol=1:cols
            if pro_base(irow,jcol) >= 2
                pro_res(irow,jcol)=255;
            end
        end
    end
    
    %С����ͶӰ���жϿ�����
    %��ʼ�ж�ÿһ֡�ܷ�����ͶӰ
    for iimg_c=3:imgnum  
        frameindex=iimg_c-2;
        imgname=exapimgfolder(iimg_c).name;
        img_expa=imread([exapimgdir,imgname]);
        for ihyp=1:10
            hypfolderdir=[imgdatasetdir,num2str(ihyp),'\'];        
            img_hyp=imread([hypfolderdir,imgname]);
            
            img_overlap=bitand(pro_res,img_hyp);
            overtario=sum(sum(img_overlap))/sum(sum(img_hyp));
            if overtario>recth
                %����hyp
                img_expa=bitor(img_expa,img_hyp);
                imwrite(img_expa,[exapimgdir,imgname],'bmp');
                ischanged=1;
            end

        end

    end
    if ischanged==1
        fprintf('changed\r\n');
    end
    
end


