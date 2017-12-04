function imgpro = feaext(imsegs,flow)
%extract frame features
%proposal��Ŀ
[pronum,~]=size(imsegs.npixels);
imgpro=cell(pronum,1);
%��һ��ͼ����proposals������
    for ipro=1:pronum
        %��ǰproposal�����ص�λ��
        [x,y]=find(imsegs.segimage==ipro);   
        [pixnum,~]=size(x);
        element=zeros(2,pixnum);
        element(1,:)=x';
        element(2,:)=y';
        imgpro{ipro}.elm=element;
        %��¼�˶���Ϣ
        propix=zeros(pixnum,2);
        for ipix=1:pixnum
            propix(ipix,1)=flow(x(ipix),y(ipix),1);
            propix(ipix,2)=flow(x(ipix),y(ipix),2);
        end    
        avex=mean(propix(:,1));
        avey=mean(propix(:,2));
        varx=var(propix(:,1));
        vary=var(propix(:,2));
        property=[avex,avey,varx,vary];
        imgpro{ipro}.pro=property;

    end

end

