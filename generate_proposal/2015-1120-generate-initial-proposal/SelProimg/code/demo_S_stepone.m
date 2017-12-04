%�����չ��
  %�����˳�ʼ�����öȱ�1-���Σ�0-������;-1-δ�ж�
  %3��hypothesisѭ�����ǣ���������Ĳ�̫��
%�Ե�һ֡Ϊ�������Ѱ��

clear
clc

rgbimgfolder_dir='H:\yangle\SegTrack\SegTrackv2\JPEGImages\';
imdatasetdir='H:\yangle\Initialization\dataset\SelectedProposal\';
opticalflowsetdir='H:\yangle\SegTrack\opticalflow\frame-1\';

classfolder=dir(imdatasetdir);
[classnum,~]=size(classfolder);
%�������
errstatus=cell(1,classnum);
for icla=3:classnum
    tic
    videoname=classfolder(icla).name;
    fprintf('%s',videoname);
    imgvideodir=[imdatasetdir,videoname,'\'];
    opticalflowdir=[opticalflowsetdir,videoname,'\'];
    rgbvideodir=[rgbimgfolder_dir,videoname,'\'];
    
    imgfolder=dir([imgvideodir,'1\']);
    [imgnum,~]=size(imgfolder);
    changelable_now=zeros(1,imgnum-2);
    isstill=1;
    count=0;
    while isstill==1
        count=count+1;
        isstill=0;    
        believelable=-1*ones(1,imgnum-2);
        changelable_last=changelable_now;
        believelable=IniBelJudge(believelable,imgvideodir,opticalflowdir,rgbvideodir);
        [believelable]=RefineInBelLable(believelable,imgvideodir,opticalflowdir,rgbvideodir);
        [believelable,changelable_now]=SelectIniFrame(believelable,changelable_last,imgvideodir,opticalflowdir,rgbvideodir);
        %����Ƿ��б仯
        for ic=1:imgnum-2
            if changelable_last(ic)~=changelable_now(ic)
               isstill=1;
               fprintf('%s circle %d\r\n',videoname,count);
               break;
            end
        end
    end
%    
thlow=0.4;
thhigh=0.85;
while isstill==1
    count=count+1;
    isstill=0;
    changelable_last=changelable_now;
    globalinilable=ones(1,imgnum-2);
    globalinilable=IniGlobalJudge(globalinilable,imgvideodir,thlow,thhigh);
    [globalinilable,changelable_now]=SelectIniFrame(globalinilable,changelable_last,imgvideodir,opticalflowdir,rgbvideodir);
    for ic=1:imgnum-2
        if changelable_last(ic)~=changelable_now(ic)
           isstill=1;
           break;
        end
    end
end

end

