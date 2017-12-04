clear
clc

imgfolderpath='H:\yangle\Initialization\dataset\dataset\';
midfolderpath='H:\yangle\Initialization\dataset\midresult\';
resfolderpath='H:\yangle\Initialization\dataset\finalresult\';

imgclassfolder=dir(imgfolderpath);
classnum=length(imgclassfolder);
%��־����ѡ��dataset�еĽ������result�еĽ��
ratiodoc=zeros(1,classnum-2);
for icla=3:classnum
    classname=imgclassfolder(icla).name   
    
    numratio=10;
    while numratio>5
        %�任�ļ���
        sfolder=dir([midfolderpath,classname]);
        foldersize=length(sfolder);
        if foldersize>2
            rmdir([imgfolderpath,classname],'s');
            copyfile([midfolderpath,classname],[imgfolderpath,classname]);        
            rmdir([midfolderpath,classname],'s');
        end        
        imgpath=[imgfolderpath,classname,'\'];        
        %�����ļ���
        mkdir([midfolderpath,classname]);
        resultpath=[midfolderpath,classname,'\'];        
        imgfolder=dir(imgpath);
        imgfolder=imgfolder(3:length(imgfolder));
        [imgnum,~]=size(imgfolder);
        framepixnum=zeros(imgnum,1);
        for iimg=1:imgnum
            imgname=imgfolder(iimg).name;
            proimg=imread([imgpath,imgname]);
            framepixnum(iimg)=sum(sum(proimg));
        end
        %�������ص����Ŀ��ͼ����࣬�۳�����
        %Kmeans�����������ڵĲ�������
        clusterid=kmeans(framepixnum,2);
        cluster1=find(clusterid==1);
        cluster2=find(clusterid==2);
        
        %��Ϊǰ��ĸ��ɿ�
        numset1=find(cluster1<(imgnum/2));
        numset2=find(cluster2<(imgnum/2));
        num1=length(numset1);
        num2=length(numset2);
        if num1>num2
            choorder=cluster1;
        else
            choorder=cluster2;
        end
        %����ѡ���ͼ��
        for iimg=1:length(choorder)
            imgname=imgfolder(choorder(iimg)).name;
            proimg=imread([imgpath,imgname]);
            imwrite(proimg,[resultpath,imgname],'png');
        end        
        
        %���������������ɢ�̶�
        %�����Ƿ��ٴμ���
        avgpixnum1=mean(framepixnum(cluster1));
        avgpixnum2=mean(framepixnum(cluster2));
        if avgpixnum1>avgpixnum2
            numratio=avgpixnum1/avgpixnum2;
        else
            numratio=avgpixnum2/avgpixnum1;
        end
        if numratio>5
            ratiodoc(icla-2)=numratio;
        end
        
    end
    
end

%��ѡ���յĽ��,ע��ͼ������
for icla=3:classnum
    imgfolder=dir([imgfolderpath,imgclassfolder(icla).name,'\']);
    imgname=imgfolder(3).name;
    imgtype=imgname(length(imgname)-2:length(imgname));
    if ratiodoc==0
        copyfile([imgfolderpath,imgclassfolder(icla).name,'\*.',imgtype],[resfolderpath,imgclassfolder(icla).name,'\']);
    else
        copyfile([midfolderpath,imgclassfolder(icla).name,'\*.',imgtype],[resfolderpath,imgclassfolder(icla).name,'\']);
    end
    
end



