function vpix_out=pixweight(supgt,hingelossmat,vpix_in,gamma,choper,negpos)
%��ǰ���������ص�����ѡ���ԣ���������м�Ȩ

[x,y]=find(supgt==negpos);
posnum=length(x);
poslosscol=zeros(posnum,1);
for ipos=1:posnum
    poslosscol(ipos)=hingelossmat(x(ipos),y(ipos));
end
posscore=sort(poslosscol);

lamda=posscore(round(posnum*choper));
%���ٽ�ֵ
for ith=round(posnum*choper):posnum
    if posscore(ith)>=lamda+gamma/(2*sqrt(ith))
        vth=posscore(ith);
        lth=find(posscore==vth);
        m=length(lth);        
        %vequalΪ������ʵ����û�к���
        vequal=((gamma/(2*(vth-lamda)))^2-(ith-1))/m;        
        break;
    end
end
lablepossmall=poslosscol;
for iv=1:posnum
    if lablepossmall(iv)<vth
        vpix_in(x(iv),y(iv))=1;
    elseif lablepossmall(iv)==vth
        for iequl=1:m
            vpix_in(x(iv),y(iv))=vequal;
        end     
    end    
end
vpix_out=vpix_in;

end

