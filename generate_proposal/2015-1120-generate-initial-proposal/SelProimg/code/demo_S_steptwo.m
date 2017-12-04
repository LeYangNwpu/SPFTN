clear
clc

imgfolderpath='H:\yangle\Initialization\dataset\selimg\';
resfolderpath='H:\yangle\Initialization\dataset\result\';
finresfolpath='H:\yangle\Initialization\dataset\finalres\';

imgclassfolder=dir(imgfolderpath);
classnum=length(imgclassfolder);
%��־����ѡ��dataset�еĽ������result�еĽ��
ratiodoc=zeros(1,classnum-2);
for icla=3:classnum
    classname=imgclassfolder(icla).name
    imgpath=[imgfolderpath,classname,'\'];
    resultpath=[resfolderpath,classname,'\'];
    
    imgfolder=dir(imgpath);
    imgfolder=imgfolder(3:length(imgfolder));
    [imgnum,~]=size(imgfolder);
    framepixnum=zeros(imgnum,1);
    framelable=zeros(1,imgnum);
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
    avgpixnum1=mean(framepixnum(cluster1));
    avgpixnum2=mean(framepixnum(cluster2));   
    if avgpixnum1<avgpixnum2
        choorder=cluster1;
        numratio=avgpixnum2/avgpixnum1;
    else
        choorder=cluster2;
        numratio=avgpixnum1/avgpixnum2;
    end
    %����ѡ���ͼ��
    for iimg=1:length(choorder)
        imgname=imgfolder(choorder(iimg)).name;
        proimg=imread([imgpath,imgname]);
        imwrite(proimg,[resultpath,imgname]);
    end
    %ѡ���Ա������ս��
    ratiodoc(icla-2)=numratio;    
    imgtype=imgname(length(imgname)-2:length(imgname));
    if numratio<6
        copyfile([imgfolderpath,imgclassfolder(icla).name,'\*.',imgtype],[finresfolpath,imgclassfolder(icla).name,'\']);
    else
        copyfile([resfolderpath,imgclassfolder(icla).name,'\*.',imgtype],[finresfolpath,imgclassfolder(icla).name,'\']);
    end
        
end
