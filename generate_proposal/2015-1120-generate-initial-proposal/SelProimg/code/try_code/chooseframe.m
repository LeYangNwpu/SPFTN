clear
clc

imgpath='H:\yangle\SegTrack\datasetnow\dataset\';
resultpath='H:\yangle\SegTrack\datasetnow\result\';

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
else
    choorder=cluster2;
end
%����ѡ���ͼ��

for iimg=1:length(choorder)
    imgname=imgfolder(choorder(iimg)).name;
    proimg=imread([imgpath,imgname]);
    imwrite(proimg,[resultpath,imgname],'png');
end

%�ж�ѡ����ÿ֡�Ƿ����








