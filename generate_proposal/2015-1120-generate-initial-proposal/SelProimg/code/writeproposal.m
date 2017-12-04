function writeproposal( Segs,imgdir,resultdatasetdir )
%��proposal�Ľ��д�뵽ͼƬ��

imgfolder=dir(imgdir);
[imgnum,~]=size(imgfolder);
for iimg=3:imgnum-1
   imgname=imgfolder(iimg).name; 
   frameindex=iimg-2;
   for ifol=1:10       
       folorder=num2str(ifol);
       imgorder=(frameindex-1)*10+ifol;
       img=Segs(imgorder).proposal;
       resultdir=[resultdatasetdir,folorder];
       if ~exist(resultdir,'dir')
           mkdir(resultdir);
       end
       imwrite(img,[resultdir,'\',imgname],'bmp');       
   end
end

end

