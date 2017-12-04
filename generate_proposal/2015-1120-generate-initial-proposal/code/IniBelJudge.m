function believelable_out=IniBelJudge(believelable_in,imdatasetdir,opticalflowdir,rgbimgfolder_dir)
%��ʼ�ж�ÿһ֡�Ƿ����
%���������
  %believelable_in����ʼ���ζȱ�
  %imdatasetdir�����ÿһ������������ļ��У�1��2��3�ȣ���Ŀ¼
  %opticalflowdir��������Ŀ¼
%���������
  %believelable_out������������ζȱ�

imgfolder_1_dir=[imdatasetdir,'1\'];
imgfolder_2_dir=[imdatasetdir,'2\'];
imgfolder_3_dir=[imdatasetdir,'3\'];    

imgfolder_1=dir(imgfolder_1_dir);
[imgnum,~]=size(imgfolder_1);

%����ֵ���ж�����ͶӰ����Ƿ�һ��
% consth=0.10;  
%����ֵ���жϵ�ǰ֡�Ƿ����
errth=0.10; 

%�ӵڶ�֡�������ڶ�֡
cimg=imread([imdatasetdir,'1\',imgfolder_1(3).name]);
[imgrows,imgcols]=size(cimg);
allpixnum=imgrows*imgcols;
for iimg=4:imgnum-1
    frameindex=iimg-2;
    img_c=imread([imgfolder_1_dir,imgfolder_1(iimg).name]); 
    [pro_f,pro_b]=project_fb(imgfolder_1_dir,rgbimgfolder_dir,imgfolder_1,opticalflowdir,iimg);   
    
    iscons=IsConsistent(allpixnum,pro_f,pro_b);       
    if iscons==1
        %ͶӰ���ţ��ж�Ŀǰ֡�Ƿ���ͶӰһ��
        isbel=IsBelievable(img_c,pro_f,pro_b,allpixnum);        
        if isbel==1
            %��ǰ֡��������
            believelable_in(frameindex)=1;
        else
            %��Ҫ����
%             fprintf('the proposal %s is unbelievable\r',imgfolder_1(iimg).name);
            believelable_in(frameindex)=0;                     
        end        
    else
        %���һ����
        conslable=zeros(1,3);
        %hypothesis1ͶӰ������,���hypothesis��2,3��ͶӰ���
%         fprintf('frame %d %s the project results are inconstistent\r',iimg-2,imgfolder_1(iimg).name);
        %hypothesis2��3�Ľ��
        [pro_f_2,pro_b_2]=project_fb(imgfolder_2_dir,rgbimgfolder_dir,imgfolder_1,opticalflowdir,iimg); 
        conslable(2)=IsConsistent(allpixnum,pro_f_2,pro_b_2);   
        [pro_f_3,pro_b_3]=project_fb(imgfolder_3_dir,rgbimgfolder_dir,imgfolder_1,opticalflowdir,iimg); 
        conslable(3)=IsConsistent(allpixnum,pro_f_3,pro_b_3);  
        
        %��conslable���3��hypothesis����ͶӰ����Ƿ�һ�£���011�������ͶӰ���ԭͼ��
        if sum(conslable)==2
            %���Եõ���ǰ֡�ȽϿ��ŵ�ͶӰ���
            if believelable_in(frameindex-1)==0 || believelable_in(frameindex+1)==0
%                 fprintf('re-judje frame %d\r',frameindex);
                newpro_2=bitand(pro_f_2,pro_b_2);
                newpro_3=bitand(pro_f_3,pro_b_3);
                newpro_1=bitor(newpro_2,newpro_3);
                
                errorratio=sum(sum(xor(img_c,newpro_1)))/allpixnum;
                if errorratio<errth
                    believelable_in(frameindex)=1;
                else
                    believelable_in(frameindex)=0;
                end
           
            end
          
        end
        
    end   
    
end
    believelable_out=believelable_in;

end

